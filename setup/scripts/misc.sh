#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/helpers/logs.sh"

log INFO "Updating /opt/.exegol_shells_rc..."
    sed -i 's/"%m"/"${HOSTNAME#exegol-}"/g' /opt/.exegol_shells_rc

log INFO "Copying rockyou.txt... for better fzf-wordlists"
    cp /opt/lists/rockyou.txt /opt/lists/aaaaaaaaaaaaaa.txt

log INFO "Fixing permissions in /workspace..."
    find /workspace/ -type d -exec chmod 770 {} \; -exec chmod g+s {} \;
    find /workspace/ -type f -exec chmod 660 {} \;

log INFO "Updating personal uberfile..."
    pipx install --system-site-packages --force git+https://github.com/Bigyls/uberfile

log INFO "Installing starship and updating shell..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    cp /opt/my-resources/setup/zsh/.zshrc ~/.zshrc
    cp /opt/my-resources/setup/zsh/startship.toml ~/.config/starship.toml
