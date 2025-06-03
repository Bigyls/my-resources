#!/bin/bash

set -e

BURPSUITE_EXTENSIONS_PATH='/opt/tools/BurpSuiteCommunity/extensions'

mkdir -p $BURPSUITE_EXTENSIONS_PATH

wget 'https://github.com/PortSwigger/hackvertor/releases/download/latest_hackvertor_release/hackvertor-all.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/hackvertor-all.jar"
wget 'https://github.com/PortSwigger/logger-plus-plus/releases/download/latest/LoggerPlusPlus.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/LoggerPlusPlus.jar"
wget 'https://github.com/lap1nou/sharpener/releases/download/latest2/sharpener.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/sharpener.jar"
wget 'https://github.com/lap1nou/piper/releases/download/latest/piper.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/piper.jar"
wget 'https://github.com/lap1nou/jwt-editor/releases/download/latest/jwt-editor-2.5.jar' -O "${BURPSUITE_EXTENSIONS_PATH}/jwt-editor-2.5.jar"

mkdir -p $BURPSUITE_EXTENSIONS_PATH/autorize

git clone https://github.com/PortSwigger/autorize.git $BURPSUITE_EXTENSIONS_PATH/autorize

cp $(dirname "$0")/../burpsuite/UserConfigCommunity.json ~/.BurpSuite/UserConfigCommunity.json 
