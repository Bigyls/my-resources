#!/bin/bash

set -e

nuclei -update-templates -t "$(dirname "$0")/../nuclei/templates"
