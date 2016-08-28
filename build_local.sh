#!/bin/bash
#
# Build local docker image
#

# change BUILDER
sed -e 's/DOCKERHUB/LOCAL/g' Dockerfile > Dockerfile.local

#set MAKEJOBS
procs=$(grep processor /proc/cpuinfo | wc -l)
procs=$((procs+1))
sed -i -e 's/\-j3/\-j'${procs}'/g' Dockerfile.local

IMAGE="$(grep IMAGE Dockerfile | awk '{print $3}' )"

# Build image
docker build -f Dockerfile.local -t ${IMAGE} .
