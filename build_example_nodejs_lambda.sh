#!/usr/bin/env bash

cd lambda/nodejs/example-nodejs-lambda

echo "> Execute NPM install"
npm install --production
echo "> Finish NPM install"

echo "> Execute packaging"
chmod 777 .
zip -r example-nodejs-lambda.zip *
echo "> Finish packaging"

echo
echo "Now execute:"
echo 'terraform apply -var "aws_access_key=${AWS_ACCESS_KEY_ID}" -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}"'
echo