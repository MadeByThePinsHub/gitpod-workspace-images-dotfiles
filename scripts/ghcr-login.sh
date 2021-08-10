#!/bin/bash

if [[ $GHCR_REGISTRY_PAT == "" ]]; then
  echo "error: Missing PAT for GitHub Container Registry login, aborting"
  exit 1
elif [[ $GHCR_USERNAME == "" ]]; then
  echo "error: Missing username for GitHub Container Registry login, aborting"
  exit 1
fi

if echo "$GHCR_REGISTRY_PAT" | docker login ghcr.io --username "$GHCR_USERNAME" --password-stdin >> /dev/null; then
  echo "Successfully logged to GHCR!"
else
  echo "Looks like something went wrong while logging in." && exit 1
fi
