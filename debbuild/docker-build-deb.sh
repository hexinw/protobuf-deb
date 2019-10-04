#!/bin/bash

set -e
set -x

# Run the build with the same uid as the outside user so that
# the build output has the same permission.
extuid=$(stat -c %u /debbuild)
extgid=$(stat -c %g /debbuild)
if [ $(id -u) != "$extuid" ]; then
  groupadd build --gid $extgid
  useradd build --groups sudo \
    --home-dir /debbuild \
    --uid $extuid \
    --gid $extgid \
    --no-create-home
  # Hack. Moved it to base image in future.
  su build "$0" "$@"
  exit 0
fi

bash
exit 0
cd ${BUILD_ROOT}/BUILD/
echo "Cleaning grpc source tree..."
dh clean

echo "Building grpc source tree..."
dh build

echo "Generate grpc deb file..."
fakeroot dh binary

#echo "Building grpc python with cython..."
#cd ${BUILD_ROOT}/BUILD/grpc/
#GRPC_PYTHON_BUILD_WITH_CYTHON=yes python setup.py bdist
#mv ${BUILD_ROOT}/grpc/dist/* ${BUILD_ROOT}/RPMS/`uname -m`
