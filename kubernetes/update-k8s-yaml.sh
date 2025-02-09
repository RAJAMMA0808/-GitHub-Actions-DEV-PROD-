#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Determine the environment based on the branch
if [[ "$GITHUB_REF" == "refs/heads/main" ]]; then
    CLUSTER_NAME="eks-cluster-prod"
    echo "Deploying to production cluster..."
else
    CLUSTER_NAME="eks-cluster-dev"
    echo "Deploying to development cluster..."
fi

# Validate if the cluster exists before updating kubeconfig
if aws eks describe-cluster --name "$CLUSTER_NAME" --region "$AWS_REGION" > /dev/null 2>&1; then
    echo "Cluster $CLUSTER_NAME found. Updating kubeconfig..."
    aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"
else
    echo "Error: No cluster found with name $CLUSTER_NAME. Deployment aborted."
    exit 1
fi
