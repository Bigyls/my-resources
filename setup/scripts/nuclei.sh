#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

TEMPLATES_DIR="$(dirname "$0")/../nuclei/templates"

# Define template repositories
declare -A templates=(
    ["custom-nuclei-templates"]="https://github.com/mdube99/custom-nuclei-templates"
    ["juicyinfo-nuclei-templates"]="https://github.com/cipher387/juicyinfo-nuclei-templates"
)

log INFO "Cleaning template repositories..."
    if [ -d "$TEMPLATES_DIR" ]; then
        rm -rf "$TEMPLATES_DIR"
        log SUCCESS "Removed existing templates directory..."
    fi

log INFO "Cloning template repositories..."
    for repo_name in "${!templates[@]}"; do
        repo_path="$TEMPLATES_DIR/$repo_name"
        if [ ! -d "$repo_path/.git" ]; then
            log INFO "Cloning ${repo_name}..."
            git clone --depth 1 "${templates[$repo_name]}" "$repo_path"
            cd "$repo_path" || exit 1
            log INFO "Cleaning up ${repo_name}..."
            rm -rf .git && rm -rf *.md
        else
            log INFO "Skipping ${repo_name} - already cloned"
        fi
    done

log INFO "Validating templates..."
    template_count=0
    while IFS= read -r -d '' template; do
        if [[ -f "$template" ]]; then
            log INFO "Validating template: $(basename "$template")"
            if nuclei -update-templates -t "$template"; then
                ((template_count++))
            else
                log ERROR "Failed to validate template: $(basename "$template")"
            fi
        fi
    done < <(find "$TEMPLATES_DIR" -type f -name "*.yaml" -print0)

log INFO "Successfully validated ${template_count} templates"

log INFO "Cleaning nuclei tmp folders..."
    if rm -rf /tmp/nuclei*; then
        log SUCCESS "Cleaned nuclei temporary files"
    else
        log ERROR "Failed to clean nuclei temporary files"
    fi
