#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

POLICY_FILENAME="policies.json"
POLICY_PATH="/usr/lib/firefox-esr/distribution"
TEMPLATE_PATH="$(dirname "$0")/../firefox/${POLICY_FILENAME}.template"

NAMES=(
    "pwnfox"
    "uaswitcher"
    "wappalyzer"
    "multi-account-containers"
    "multi-url-opener"
    "bitwarden-password-manager"
    "hacktools"
    "shodan-addon"
    "ghunt-companion"
    "ublock-origin"
    "traduzir-paginas-web"
    "cookie-quick-manager"
    "easy-xss"
    "web-developer"
    "penetration-testing-kit"
    "firefox-hackbar"
    "what-cms-is-this"
    "dotgit"
)

get_extension_id() {
    local EXT_NAME=$1

    local PAGE
    PAGE=$(curl -s -L "https://addons.mozilla.org/fr/firefox/addon/${EXT_NAME}")
    local GUID
    GUID=$(echo "$PAGE" | grep -oP '"guid":"\K[^"]+')

    if [[ -z "$GUID" ]]; then
        return 1
    fi

    echo "$GUID"
}

log INFO "Generating the Firefox policy"
    if [[ ! -f "$TEMPLATE_PATH" ]]; then
        log ERROR "Template file not found: $TEMPLATE_PATH"
        exit 1
    fi

    TMP_JSON=$(mktemp)
    cp "$TEMPLATE_PATH" "$TMP_JSON"

    for EXT_NAME in "${NAMES[@]}"; do
        EXT_GUID=$(get_extension_id "$EXT_NAME") || continue
        jq --arg guid "$EXT_GUID" --arg name "$EXT_NAME" \
            '.policies.ExtensionSettings[$guid] = {"installation_mode":"force_installed", "temporarily_allow_weak_signatures": true, "private_browsing": true, "default_area": "navbar", "install_url":("https://addons.mozilla.org/firefox/downloads/latest/" + $name + "/latest.xpi")}' \
            "$TMP_JSON" > "${TMP_JSON}.tmp" && mv "${TMP_JSON}.tmp" "$TMP_JSON"
    done

log INFO "NAMES contains ${#NAMES[@]} elements"
    cp "$TMP_JSON" "${POLICY_PATH}/${POLICY_FILENAME}"
    rm "$TMP_JSON"

log INFO "Policy written to ${POLICY_PATH}/${POLICY_FILENAME}"
