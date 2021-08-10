#!/bin/bash

if [[ $EUID != "0" ]]; then
  echo "You shoud run me as root!"
  exit 1
fi

# TODO: Install Dazzle

# Image tests
if [[ ! -f "/usr/bin/dazzle-util" ]]; then
  curl -o /usr/bin/dazzle-util -fsSL "https://github.com/csweichel/dazzle/releases/download/v0.0.3/dazzle-util_0.0.3_Linux_x86_64"
  chmod +x /usr/bin/dazzle-util
else
  rm /usr/bin/dazzle-util
  curl -o /usr/bin/dazzle-util -fsSL "https://github.com/csweichel/dazzle/releases/download/v0.0.3/dazzle-util_0.0.3_Linux_x86_64"
  chmod +x /usr/bin/dazzle-util
fi