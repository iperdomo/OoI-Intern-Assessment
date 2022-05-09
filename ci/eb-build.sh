#!/usr/bin/env bash

##################################################
# Build the Elastic Beanstalk application bundle #
##################################################

set -eu
set -o pipefail

# Set default values if `source env.sh` has not been run
CLIENT_IMAGE="${CLIENT_IMAGE:=yvantcoop/ooi-client:latest}"
BACKEND_IMAGE="${BACKEND_IMAGE:=yvantcoop/ooi-backend:latest}"
NAME="${APP_NAME:=ooi-test}"
TAG="${DOCKER_TAG:=latest}"

# Copy the deploy directory to 'build'
cp -r deploy build

# Replace default Docker image (latest) correctly tagged image for this build
cp deploy/docker-compose.yml build/docker-compose.yml
sed -i "s/:latest/:${TAG}/g" build/docker-compose.yml

# Create eb bundle zip file with contents of build directory
(
    cd build
    zip -r "${NAME}"-"${TAG}".zip .
)
