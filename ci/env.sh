#!/usr/bin/env bash

############################################################################
# Default environment variables for CI                                     #
# Intended to be sourced with 'source env.sh' before running other scripts #
############################################################################

export AWS_ACCOUNT='560315399381'
export AWS_REGION=eu-west-1
export DOCKER_ORG=yvantcoop
export APP_NAME=ooi-test
export S3_BUCKET="elasticbeanstalk-${AWS_REGION}-${AWS_ACCOUNT}"
export DOCKER_TAG="${GITHUB_SHA:=latest}"
export DOCKER_TAG="${DOCKER_TAG:0:7}"
export CLIENT_IMAGE="${DOCKER_ORG}/ooi-client:${DOCKER_TAG}"
export API_IMAGE="${DOCKER_ORG}/ooi-backend:${DOCKER_TAG}"
export COMPOSE_HTTP_TIMEOUT=180
