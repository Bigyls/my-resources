#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

BURPSUITE_EXTENSIONS_PATH='/opt/tools/BurpSuiteCommunity/extensions'

log LOG "Creating extensions directory..."
mkdir -p "$BURPSUITE_EXTENSIONS_PATH"

# Define extensions to download
declare -A extensions=(
    ["hackvertor-all.jar"]="https://github.com/PortSwigger/hackvertor/releases/download/latest_hackvertor_release/hackvertor-all.jar"
    ["LoggerPlusPlus.jar"]="https://github.com/PortSwigger/logger-plus-plus/releases/download/latest/LoggerPlusPlus.jar"
    ["sharpener.jar"]="https://github.com/lap1nou/sharpener/releases/download/latest2/sharpener.jar"
    ["piper.jar"]="https://github.com/lap1nou/piper/releases/download/latest/piper.jar"
    ["jwt-editor-2.5.jar"]="https://github.com/lap1nou/jwt-editor/releases/download/latest/jwt-editor-2.5.jar"
)

log LOG "Downloading Burp Suite extensions..."
for jar_file in "${!extensions[@]}"; do
    target_path="${BURPSUITE_EXTENSIONS_PATH}/${jar_file}"
    if [ ! -f "$target_path" ]; then
        log LOG "Downloading ${jar_file}..."
        wget -nc "${extensions[$jar_file]}" -O "$target_path"
    else
        log LOG "Skipping ${jar_file} - already exists"
    fi
done

log LOG "Cloning Autorize extension..."
mkdir -p "$BURPSUITE_EXTENSIONS_PATH/autorize"
if [ ! -d "$BURPSUITE_EXTENSIONS_PATH/autorize/.git" ]; then
    git clone --depth 1 https://github.com/PortSwigger/autorize.git "$BURPSUITE_EXTENSIONS_PATH/autorize"
else
    log LOG "Skipping Autorize - already cloned"
fi

log LOG "Copying Burp Suite user config..."
cp "$(dirname "$0")/../burpsuite/UserConfigCommunity.json" ~/.BurpSuite/UserConfigCommunity.json 
