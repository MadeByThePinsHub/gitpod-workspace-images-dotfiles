#!/bin/bash

GHCR_NAMESPACE=${GHCR_NAMESPACE:-"madebythepinshub"}
GHCR_IMAGE_REPO=${GHCR_IMAGE_REPO:-"gitpodified-dotfiles/base"}
GHCR_IMAGE_TAG=${GHCR_IMAGE_TAG:-"localdev"}
BUILD_CONTEXT_DIR="docker/base"

if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
  echo "Supported variables:"
  echo "  - GHCR_NAMESPACE: your GitHub username or org for tag generation and image push"
  echo "  - GHCR_IMAGE_REPO: Docker image name for tag generation and image push"
  echo "  - GHCR_IMAGE_TAG: Docker image tag for tag generation and image push"
  echo "  - DOCKER_BUILDKIT: Set to 0 to disable BuildKit when running docker build in this script"
  echo "  - GHCR_PUSH_IMAGE: Set to any value to also push built image to GHCR."
  echo "  - DEBUG: Set to any value to see debug stuff."
  echo
  echo "Hint: To build image from '$PWD/$BUILD_CONTEXT_DIR' directory, run me without the help command."
  exit 0
fi

[[ $DEBUG != "" ]] && echo "debug: Image name is ghcr.io/$GHCR_NAMESPACE/$GHCR_IMAGE_REPO:$GHCR_IMAGE_TAG"

if [[ $PWD != *"/$BUILD_CONTEXT_DIR" ]]; then
  DOCKER_BUILDKIT=${DOCKER_BUILDKIT:-"1"} docker build \
    --tag "ghcr.io/$GHCR_NAMESPACE/$GHCR_IMAGE_REPO:$GHCR_IMAGE_TAG" \
    --pull $BUILD_CONTEXT_DIR
else
  DOCKER_BUILDKIT=${DOCKER_BUILDKIT:-"1"} docker build \
    --tag "ghcr.io/$GHCR_NAMESPACE/$GHCR_IMAGE_REPO:$GHCR_IMAGE_TAG" \
    --pull .
fi

if [[ $GHCR_PUSH_IMAGE != "" ]]; then
  docker push "ghcr.io/$GHCR_NAMESPACE/$GHCR_IMAGE_REPO:$GHCR_IMAGE_TAG"
fi