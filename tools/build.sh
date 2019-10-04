#!/bin/bash
#
# Script to build grpc debian in docker.
#

set -e
set -x

cd $(dirname $0)/..

git submodule update --init --recursive

BUILD_ROOT=./debbuild
BUILD_CONTAINER=docker.io/hexinwang/ubuntu18-builder
BUILD_COMMAND=/debbuild/docker-build-deb.sh

echo "Launching ${BUILD_CONTAINER} ${DOCKER_BUILD_COMMAND}"
docker run \
  --rm \
  --tty \
  --interactive \
  --volume $(readlink -f "${BUILD_ROOT}"):/debbuild:z \
  --env BUILD_ROOT=/debbuild \
  --workdir /debbuild \
  ${BUILD_CONTAINER} \
  ${BUILD_COMMAND}
