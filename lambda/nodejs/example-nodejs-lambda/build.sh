#!/usr/bin/env bash

cd lambda/nodejs/example-nodejs-lambda/

echo "> Execute NPM install"
npm install --production
echo "> Finish NPM install"

echo "> Execute packaging"
chmod 777 .
zip -r example-nodejs-lambda.zip *.js *.json
echo "> Finish packaging"

echo
echo "Now execute:"
echo "terraform plan|apply"
echo
