#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

BURPSUITE_EXTENSIONS_PATH='/opt/tools/BurpSuiteCommunity/extensions'

log LOG "Creating extensions directory..."
mkdir -p "$BURPSUITE_EXTENSIONS_PATH"

log LOG "Downloading Burp Suite extensions..."
wget -nc 'https://github.com/PortSwigger/hackvertor/releases/download/latest_hackvertor_release/hackvertor-all.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/hackvertor-all.jar"
wget -nc 'https://github.com/PortSwigger/logger-plus-plus/releases/download/latest/LoggerPlusPlus.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/LoggerPlusPlus.jar"
wget -nc 'https://github.com/lap1nou/sharpener/releases/download/latest2/sharpener.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/sharpener.jar"
wget -nc 'https://github.com/lap1nou/piper/releases/download/latest/piper.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/piper.jar"
wget -nc 'https://github.com/lap1nou/jwt-editor/releases/download/latest/jwt-editor-2.5.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/jwt-editor-2.5.jar"

log LOG "Cloning Autorize extension..."
mkdir -p "$BURPSUITE_EXTENSIONS_PATH/autorize"
if [ ! -d "$BURPSUITE_EXTENSIONS_PATH/autorize/.git" ]; then
  git clone https://github.com/PortSwigger/autorize.git "$BURPSUITE_EXTENSIONS_PATH/autorize"
fi

log LOG "Copying Burp Suite user config..."
cp "$(dirname "$0")/../burpsuite/UserConfigCommunity.json" ~/.BurpSuite/UserConfigCommunity.json 
