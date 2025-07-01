#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Starting neo4j service..."
    neo4j start
