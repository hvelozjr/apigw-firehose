#!/bin/sh
STACK_NAME=firehose-thing
REGION=us-west-2

aws --region $REGION cloudformation deploy --template-file firehose.yml --stack-name $STACK_NAME --parameter-overrides Environment=dev --capabilities CAPABILITY_IAM
