#!/usr/bin/env bash
set -euo pipefail
: "${AWS_REGION:?Set AWS_REGION}"
: "${CLUSTER_NAME:=streamingapp-demo}"
# Example only. EKS resources incur AWS charges. Review quotas, VPC, IAM and costs first.
eksctl create cluster --name "$CLUSTER_NAME" --region "$AWS_REGION" --nodes 2 --node-type t3.large --managed
aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"
