#!/bin/bash

set -e

[ ! -d ~/.ssh ] && mkdir ~/.ssh
chmod -R 750 ~/.ssh

cp $(dirname "$0")/../ssh/config ~/.ssh/config 
