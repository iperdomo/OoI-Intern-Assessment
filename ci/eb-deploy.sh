#!/usr/bin/env bash

######################################################
# Deploy the application bundle to Elastic Beanstalk #
######################################################

set -eu

# Requires Elastic Beanstalk environment argument
if [ -z "$1" ]; then
  echo "Usage ./eb-deploy.sh <environment>"
  exit 1
fi

EB_ENVIRONMENT="$1"

# Set default values if `source env.sh` has not been run
APP_NAME="${APP_NAME:=ooi-test}" # TODO Change to ooi-sample
TAG="${DOCKER_TAG:=latest}"
AWS_REGION="${AWS_REGION:=eu-west-1}"

# Deploy to Elastic Beanstalk using AWS CLI
aws elasticbeanstalk update-environment --region "${AWS_REGION}" \
    --application-name "${APP_NAME}" \
    --environment-name "${EB_ENVIRONMENT}" \
    --version-label "${TAG}"
