#!/bin/sh

STACK_NAME=firehose-thing
REGION=us-west-2

API_GW_ENDPOINT=$(aws --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey == `ServiceEndpoint`].{out:OutputValue}' --output text)
FIREHOSE_NAME=$(aws --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey == `Firehose`].{out:OutputValue}' --output text)




while IFS='' read -r LINE || [ -n "${LINE}" ]; do
  # RECORD=$(echo $LINE | base64)
  curl -H "Content-Type: application/json" -X POST $API_GW_ENDPOINT -d "
  {
      \"DeliveryStreamName\": \"$FIREHOSE_NAME\",
      \"Record\": {
        \"Data\": \"${LINE}\n\"
      }
  }"
done < data/moviedata2.csv
