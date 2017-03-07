#!/usr/bin/env bash
#
# A provision script for Vagrant to setup a Swift-ready development environment.
# Author: Nikolai Vazquez (https://github.com/nvzqz)

set -e

sudo apt-get update
sudo apt-get install -y git zsh clang libicu-dev

sudo chsh -s /bin/zsh vagrant

SWIFT_VERSION="swift-3.0.2"
SWIFTENV_ROOT="$HOME/.swiftenv"

if [ ! -d "$SWIFTENV_ROOT" ]; then
    git clone https://github.com/kylef/swiftenv.git "$SWIFTENV_ROOT"
    echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.zshrc
    echo 'export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"' >> ~/.zshrc
fi

source ~/.zshrc

echo "Installing $SWIFT_VERSION..."
swiftenv install "$SWIFT_VERSION" > /dev/null 2>&1
