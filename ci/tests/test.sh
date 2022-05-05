#!/usr/bin/env bash

set -eu -o pipefail

./wait-for-it.sh --quiet client:80 -- echo "client is up"
./wait-for-it.sh --quiet api:9000 -- echo "api is up"

curl --fail --verbose http://client 2>&1 | grep -E '<.*200 OK'
curl --fail --verbose http://client/api/status/ 2>&1 | grep -E '<.*200 OK'
