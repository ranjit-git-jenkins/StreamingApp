#!/usr/bin/env bash
set -euo pipefail
: "${AWS_REGION:?Set AWS_REGION}"
for service in authservice streamingservice adminservice chatservice frontend; do
  aws ecr describe-repositories --region "$AWS_REGION" --repository-names "streamingapp-$service" >/dev/null 2>&1 ||     aws ecr create-repository --region "$AWS_REGION" --repository-name "streamingapp-$service" --image-scanning-configuration scanOnPush=true
 done
