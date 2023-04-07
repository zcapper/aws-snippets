These templates set up a basic S3-hosted website with CloudFront for HTTPS.

See `deploy.sh` for an example of end to end usage.

Steps:
1. Deploy `website-certificate.yaml` to us-east-1
2. Deploy `website.yaml` to any region you prefer
3. Upload an index.html to the website S3 bucket
