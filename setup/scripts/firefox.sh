#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Removing Firefox extensions and bookmarks installed by Exegol..."
rm -f /root/.mozilla/firefox/*.Exegol/extensions/*
rm -f /root/.mozilla/firefox/*.Exegol/places.sqlite

log INFO "Applying Firefox policy..."
cp "$(dirname "$0")/../firefox/policies.json" /usr/lib/firefox-esr/distribution/

POLICY_FILENAME="policies.json"
POLICY_PATH="/usr/lib/firefox-esr/distribution"
TEMPLATE_PATH="/opt/tools/firefox/${POLICY_FILENAME}.template"

NAMES=(
    "foxyproxy-standard"
    "uaswitcher"
    "cookie-editor"
    "wappalyzer"
    "multi-account-containers"
    "multi-url-opener"
)

get_extension_id() {
    local EXT_NAME=$1
    log INFO "Getting extension ID for $EXT_NAME"

    local PAGE
    PAGE=$(curl -s "https://addons.mozilla.org/fr/firefox/addon/${EXT_NAME}")
    local GUID
    GUID=$(echo "$PAGE" | grep -oP '"guid":"\K[^"]+')

    if [[ -z "$GUID" ]]; then
        log_error "Couldn't get extension id for $EXT_NAME"
        return 1
    fi

    echo "$GUID"
}

generate_firefox_policy() {
    log INFO "Generating the Firefox policy"

    if [[ ! -f "$TEMPLATE_PATH" ]]; then
        log ERROR "Template file not found: $TEMPLATE_PATH"
        exit 1
    fi

    local TMP_JSON
    TMP_JSON=$(mktemp)
    cp "$TEMPLATE_PATH" "$TMP_JSON"

    for EXT_NAME in "${NAMES[@]}"; do
        EXT_GUID=$(get_extension_id "$EXT_NAME") || continue
        jq --arg guid "$EXT_GUID" --arg name "$EXT_NAME" \
           '.policies.ExtensionSettings[$guid] = {"installation_mode":"force_installed", "install_url":("https://addons.mozilla.org/firefox/downloads/latest/" + $name + "/latest.xpi")}' \
           "$TMP_JSON" > "${TMP_JSON}.tmp" && mv "${TMP_JSON}.tmp" "$TMP_JSON"
    done

    sudo cp "$TMP_JSON" "${POLICY_PATH}/${POLICY_FILENAME}"
    rm "$TMP_JSON"

    log INFO "Policy written to ${POLICY_PATH}/${POLICY_FILENAME}"
}

generate_firefox_policy
