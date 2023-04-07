#!/bin/bash

DOMAIN_NAME=foo.com
HOSTED_ZONE_ID=abc
S3_BUCKET_REGION=ap-southeast-1

aws cloudformation deploy \
  --stack-name website-${DOMAIN_NAME//./-}-certificate \
  --template-file website-certificate.yaml \
  --parameter-overrides DomainName=${DOMAIN_NAME} \
  --region us-east-1

ACM_CERTIFICATE_ARN=$(
  aws cloudformation describe-stacks \
    --stack-name website-${DOMAIN_NAME//./-}-certificate \
    --query 'Stacks[0].Outputs[?OutputKey==`AcmCertificateArn`].OutputValue' \
    --output text \
    --region us-east-1
)

aws cloudformation deploy \
  --stack-name website-${DOMAIN_NAME//./-} \
  --template-file website.yaml \
  --parameter-overrides \
    DomainName=${DOMAIN_NAME} \
    AcmCertificateArn=${ACM_CERTIFICATE_ARN} \
    HostedZoneId=${HOSTED_ZONE_ID} \
  --region ${S3_BUCKET_REGION}

echo '<html><head></head><body>Hello world</body></html>' \
  | aws s3 cp - s3://${DOMAIN_NAME}/index.html \
    --content-type text/html \
    --region ${S3_BUCKET_REGION}
