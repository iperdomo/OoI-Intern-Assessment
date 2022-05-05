#!/usr/bin/env bash

set -eu

CI_COMMIT="${CI_COMMIT:=local}"
CI_COMMIT="${CI_COMMIT:0:7}"

dci() {
	docker-compose -f docker-compose.yml -f docker-compose.ci.yml "$@"
}
export -f dci

dct() {
	docker-compose -f docker-compose.yml -f docker-compose.test.yml "$@"
}
export -f dct

dci up -d
echo "Installing api dependencies..."
dci exec api bash -c 'set -e; npm ci --no-progress'

echo "Installing client dependencies..."
dci exec client bash -c 'set -e; npm ci --no-progress'

echo "Running client tests..."
dci exec client bash -c 'set -e; npm run test'

echo "Running client production build..."
dci exec client bash -c 'set -e; npm run build'

echo "Building Docker images..."
docker build \
	-t "yvantcoop/ooi-backend:${CI_COMMIT}" \
	-t "yvantcoop/ooi-backend:latest" .

echo "Building client image..."
(
	cd client
	docker build \
		-t "yvantcoop/ooi-client:${CI_COMMIT}" \
		-t "yvantcoop/ooi-client:latest" .
)


echo "Testing images..."
dct up -d

echo "Done"
