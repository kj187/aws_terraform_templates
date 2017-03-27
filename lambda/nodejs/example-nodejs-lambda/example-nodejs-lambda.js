
var async = require('async');
var AWS = require('aws-sdk');
var gm = require('gm').subClass({ imageMagick: true }); // Enable ImageMagick integration.
var util = require('util');
var path = require('path');
var s3 = new AWS.S3();

exports.handler = function(event, context, callback) {
    var srcBucket = event.Records[0].s3.bucket.name;
    var dstBucket = srcBucket + "resized";
    var srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));
    var typeMatch = srcKey.match(/\.([^.]*)$/);
    if (!typeMatch) {
        callback("Could not determine the image type.");
        return;
    }

    var imageType = typeMatch[1];
    if (imageType != "jpg" && imageType != "png") {
        callback('Unsupported image type: ${imageType}');
        return;
    }

    async.waterfall([
            function(next) {
                console.log("Download the image from S3 into a buffer ...");
                s3.getObject({ Bucket: srcBucket, Key: srcKey }, next);
            },
            function(response, next) {
                console.log("Starting transforming ...");
                gm(response.Body).size(function(error, size) {
                    if (error) {
                        next(error); return;
                    }
                    var scalingFactor = Math.min(100 / size.width, 100 / size.height);
                    var width	= scalingFactor * size.width;
                    var height = scalingFactor * size.height;
                    this.resize(width, height).toBuffer(imageType, function(error, buffer) {
                        if (error) {
                            next(error);
                        } else {
                            next(null, response.ContentType, buffer);
                        }
                    });

                });
            },
            function(contentType, data, next) {
                console.log("Upload to s3://" + dstBucket + "/thumbnails/" + path.basename(srcKey));
                s3.putObject({
                    Bucket: dstBucket,
                    Key: path.basename(srcKey),
                    Body: data,
                    ContentType: contentType
                }, next);
            }
        ], function(error) {
            if (error) {
                console.error(error);
                callback(error);
            }

            callback(null, "Successfully resized");
        }
    );
};
