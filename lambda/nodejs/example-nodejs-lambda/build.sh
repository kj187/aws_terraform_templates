#!/usr/bin/env bash

cd lambda/nodejs/example-nodejs-lambda/
npm install --production
chmod 777 .
zip -r example-nodejs-lambda.zip *.js *.json node_modules

echo
echo "Now execute:"
echo "terraform plan|apply"
echo
