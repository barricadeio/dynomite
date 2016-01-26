#!/usr/bin/env bash

# Login to docker-registry
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD -e $DOCKER_EMAIL $DOCKER_REGISTRY

# Build dashboard docker image with docker tag as cirlceci build number
docker build -t $DOCKER_REGISTRY/docker-dynomite:$CIRCLE_BRANCH-$CIRCLE_BUILD_NUM docker

# Push the above image to barricade's docker registry
docker push $DOCKER_REGISTRY/docker-dynomite:$CIRCLE_BRANCH-$CIRCLE_BUILD_NUM

# Tag latest of each branch
docker tag $DOCKER_REGISTRY/docker-dynomite:$CIRCLE_BRANCH-$CIRCLE_BUILD_NUM $DOCKER_REGISTRY/docker-dynomite:latest-$CIRCLE_BRANCH

# Push the latest image of each branch to barricade's docker registry
docker push $DOCKER_REGISTRY/docker-dynomite:latest-$CIRCLE_BRANCH
