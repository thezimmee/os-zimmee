#!/usr/bin/env bash

# Set $OSZ_ROOT
if [ -z $OSZ_ROOT ]; then
  read -e -p "[??] Where is OS Zimmee installed? " -i "$HOME/Projects/os-zimmee" reply
  OSZ_ROOT=$reply
fi
