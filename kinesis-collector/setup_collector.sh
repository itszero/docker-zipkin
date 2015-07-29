#!/bin/bash

DEPLOY_BUCKET=knewton-utility-build

# Get latest tdist-zipkin version
latest_version=\
    `aws s3 ls s3://${DEPLOY_BUCKET}/tdist-zipkin- | tail -n 1 | tr -s ' ' | cut -d ' ' -f 4`

aws s3 cp s3://${DEPLOY_BUCKET}/${latest_version} ~/