#!/usr/bin/env bash

set -eux

CI_COMMIT="${CI_COMMIT:=local}"
CI_COMMIT="${CI_COMMIT:0:7}"

dci() {
	docker-compose -f docker-compose.yml -f docker-compose.ci.yml "$@"
}
export -f dci

dcie() {
	dci exec --no-TTY "$@"
}
export -f dcie

dct() {
	docker-compose -f docker-compose.yml -f docker-compose.test.yml "$@"
}
export -f dct

echo "Starting system..."
dci up --build --detach

echo "Running client tests..."
dcie client npm run test

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
