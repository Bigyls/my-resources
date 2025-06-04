#!/bin/bash
# DEPENDS_ON: all

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log LOG "Starting neo4j service..."
neo4j start
