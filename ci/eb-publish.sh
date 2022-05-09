#!/usr/bin/env bash

######################################################
# Deploy the application bundle to Elastic Beanstalk #
######################################################

set -eu
set -o pipefail

# Set default values if `source env.sh` has not been run
BACKEND_IMAGE="${BACKEND_IMAGE:=yvantcoop/ooi-backend:latest}"
NAME="${APP_NAME:=ooi-test}"
TAG="$(echo $BACKEND_IMAGE | cut -d: -f2)"
APP_VERSION="${NAME}-${TAG}"
AWS_REGION="${AWS_REGION:=eu-west-1}"

# Fail if application bundle not found
if [ ! -f "build/${APP_VERSION}.zip" ]; then
  printf "Build file not found."
  exit 1
fi

FILE_PATH="build/${APP_VERSION}.zip"
FILE="$(basename "${FILE_PATH}")"
DESCRIPTION="$(git log -1 --pretty=%s)"
S3_KEY="${NAME}/${FILE}"

# To support local deploys allow single description argument
if [ $# -eq 1 ]; then
  DESCRIPTION=$1
fi

# Upload application to s3
aws s3 cp "${FILE_PATH}" "s3://${S3_BUCKET}/${NAME}/"

# Create application version in Elastic Beanstalk
echo "Creating new ${NAME} application version ${TAG} with description '${DESCRIPTION}'"
aws elasticbeanstalk create-application-version --region "${AWS_REGION}" \
    --application-name "${NAME}" \
    --version-label "${TAG}" \
    --description "${DESCRIPTION}" \
    --source-bundle "S3Bucket=${S3_BUCKET},S3Key=${S3_KEY}"
