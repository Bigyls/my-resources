#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

TEMPLATES_DIR="$(dirname "$0")/../nuclei/templates"

# Define template repositories
declare -A templates=(
    ["custom-nuclei-templates"]="https://github.com/mdube99/custom-nuclei-templates"
    ["juicyinfo-nuclei-templates"]="https://github.com/cipher387/juicyinfo-nuclei-templates"
)

log LOG "Cloning template repositories..."
for repo_name in "${!templates[@]}"; do
    repo_path="$TEMPLATES_DIR/$repo_name"
    if [ ! -d "$repo_path/.git" ]; then
        log LOG "Cloning ${repo_name}..."
        git clone --depth 1 "${templates[$repo_name]}" "$repo_path"
        cd "$repo_path" || exit 1
        log LOG "Cleaning up ${repo_name}..."
        rm -rf .git && rm -rf *.md
    else
        log LOG "Skipping ${repo_name} - already cloned"
    fi
done

log LOG "Validating templates..."
template_count=0
while IFS= read -r -d '' template; do
    if [[ -f "$template" ]]; then
        log LOG "Validating template: $(basename "$template")"
        if nuclei -update-templates -t "$template"; then
            ((template_count++))
        else
            log ERROR "Failed to validate template: $(basename "$template")"
        fi
    fi
done < <(find "$TEMPLATES_DIR" -type f -name "*.yaml" -print0)
log LOG "Successfully validated ${template_count} templates"

log LOG "Cleaning nuclei tmp folders..."
if rm -rf /tmp/nuclei*; then
    log LOG "Successfully cleaned nuclei temporary files"
else
    log ERROR "Failed to clean nuclei temporary files"
fi
