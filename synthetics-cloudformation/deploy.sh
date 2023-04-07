#!/bin/bash

# Make sure your AWS credentials are available or export the AWS_ACCESS_KEY_ID,
# AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN env vars.

export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:=us-east-1}

ansible-playbook \
  --inventory=localhost, \
  --extra-vars "aws_region=${AWS_DEFAULT_REGION}" \
  ansible/deploy.yaml
