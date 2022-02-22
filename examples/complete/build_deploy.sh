#!/usr/bin/env bash
terraform apply -auto-approve
BUCKET=$(terraform output --raw -no-color s3_bucket_id)
CLOUDFRONT=$(terraform output -raw -no-color cloudfront_distribution_id)
cd example_site
rm -rf out/
yarn install && yarn build && yarn export
aws s3 sync --only-show-errors --delete out/ "s3://$BUCKET/"
INVALIDATION_ID=$(aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT" --paths "/*" --query 'Invalidation.Id' --output text)
# aws cloudfront wait invalidation-completed --distribution-id "$CLOUDFRONT" --id "$INVALIDATION_ID"
