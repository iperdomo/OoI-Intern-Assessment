#!/usr/bin/env bash

set -eu

CI_COMMIT="${CI_COMMIT:=local}"
CI_COMMIT="${CI_COMMIT:0:7}"

# We expect that a previous step performs the login to Docker Hub
docker push "yvantcoop/ooi-client:${CI_COMMIT}"
docker push "yvantcoop/ooi-backend:${CI_COMMIT}"
