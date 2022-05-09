#!/usr/bin/env bash

########################################
# Utility for local build and deploys  #
########################################

set -e

# Elastic Beanstalk environment must be set on command line
if [ -z "$1" ]; then
  echo "Usage ./local-deploy.sh <environment>"
  exit 1
fi

EB_ENVIRONMENT="$1"

CI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Generate a random GITHUB_SHA to be used as application version label
# shellcheck disable=SC2012
GITHUB_SHA=$(ls -alR . | sha1sum | head -c 40)
export GITHUB_SHA

# shellcheck source=ci/env.sh disable=SC1091
source "${CI_DIR}"/env.sh

# Remove existing build if it exists
if [ -d build ]; then
  printf "Removing %s\n" build/
  rm -rf build
fi

# Build Docker image
# shellcheck source=ci/build.sh disable=SC1091
#. "${CI_DIR}"/build.sh

# Build Elastic Beanstalk application bundle
# shellcheck source=ci/eb-build.sh disable=SC1091
. "${CI_DIR}"/eb-build.sh

# Push Docker image to ECR
# shellcheck source=ci/publish.sh disable=SC1091
#. "${CI_DIR}"/publish.sh

# Publish Elastic Beanstalk application bundle
# shellcheck source=ci/eb-publish.sh disable=SC1091
. "${CI_DIR}"/eb-publish.sh "Local deploy"

# Deploy application version to Elastic Beanstalk environment
# shellcheck source=ci/eb-deploy.sh disable=SC1091
. "${CI_DIR}"/eb-deploy.sh "$EB_ENVIRONMENT"
