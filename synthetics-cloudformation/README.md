This is a full working example of how you can deploy AWS Synthetics Canaries
using CloudFormation and Ansible.

Simply export your AWS_DEFAULT_REGION env var and run deploy.sh.

There are two CloudFormation templates.
1. synthetics-base.yaml - this template contains common resources used by
   Canaries. One stack should be deployed in each region you will be using
   Canaries.
2. canary.yaml - this template contains the actual canary definition. One
   stack per canary.
