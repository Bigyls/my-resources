#!/bin/bash

set -e

git clone https://github.com/mdube99/custom-nuclei-templates "$(dirname "$0")/../nuclei/templates"
git clone https://github.com/cipher387/juicyinfo-nuclei-templates "$(dirname "$0")/../nuclei/templates"

nuclei -update-templates -t "$(dirname "$0")/../nuclei/templates"
