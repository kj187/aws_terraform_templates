
exports.handler = function (event, context) {
    var srcBucket = event.Records[0].s3.bucket.name;
    var srcKey    = event.Records[0].s3.object.key;
    var dstKey = "thumb-" + srcKey;    
    
    console.log("Creating thumbnail: ", srcBucket + dstKey)
    
    context.done(null, 'success');
}