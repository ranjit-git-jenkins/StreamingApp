#!/usr/bin/env bash
set -euo pipefail
: "${AWS_ACCOUNT_ID:?Set AWS_ACCOUNT_ID}"
: "${AWS_REGION:?Set AWS_REGION}"
: "${IMAGE_TAG:?Set IMAGE_TAG}"
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
helm upgrade --install streamingapp ./helm/streamingapp --namespace streamingapp --create-namespace  --set global.registry="$REGISTRY" --set global.tag="$IMAGE_TAG"  --set secrets.mongoUri="$MONGO_URI" # DEMO ONLY: avoid passing secrets via CLI in production
