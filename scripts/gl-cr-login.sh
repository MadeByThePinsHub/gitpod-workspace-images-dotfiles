#!/bin/bash

GITLAB_CONTAINER_REGISTRY_HOST=${GITLAB_CONTAINER_REGISTRY_HOST:-"registry.gitlab.com"}
GITLAB_CONTAINER_REGISTRY_PROXY=${GITLAB_HOST:-"gitlab.com"}

if [[ $GITLAB_CONTAINER_REGISTRY_PASSWORD == "" ]]; then
  echo "error: Missing PAT for GitHub Container Registry login, aborting"
  exit 1
elif [[ $GITLAB_CONTAINER_REGISTRY_USERNAME == "" ]]; then
  echo "error: Missing username for GitHub Container Registry login, aborting"
  exit 1
fi

if echo "$GITLAB_CONTAINER_REGISTRY_PASSWORD" | docker login "$GITLAB_CONTAINER_REGISTRY_HOST" --username "$GHCR_USERNAME" --password-stdin; then
  echo "Successfully logged to GitLab Container Registry!"
else
  echo "Looks like something went wrong while logging in." && exit 1
fi

if [[ $GITLAB_DEPENDENCY_PROXY == "true" ]]; then
  echo "$GITLAB_CONTAINER_REGISTRY_PASSWORD" | docker login "$GITLAB_CONTAINER_REGISTRY_PROXY" --username "$GHCR_USERNAME" --password-stdin
fi