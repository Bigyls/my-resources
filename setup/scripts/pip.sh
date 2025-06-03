#!/bin/bash

set -e

pip3 install \
  hekatomb

pipx install \
  ghunt \
  secator \
  git+https://github.com/nccgroup/GTFOBLookup 
