#!/bin/bash

SKIP_CR_LOGIN_REASON=${SKIP_CR_LOGIN_REASON:-"unknown"}

if [[ $SKIP_CR_LOGIN != "" ]]; then
  echo "warning: Container registry signin has been skipped due to the following reason: $SKIP_CR_LOGIN_REASON"
  exit 0
fi

# GHCR
./scripts/ghcr-login.sh
# GitLab Container Registry
./scripts/gl-cr-login.sh