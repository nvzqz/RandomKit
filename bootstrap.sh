#!/usr/bin/env bash
#
# A provision script for Vagrant to setup a Swift-ready development environment.
# Author: Nikolai Vazquez (https://github.com/nvzqz)
# Platform: Ubuntu 14.04  (ubuntu/trusty64)

set -e

sudo apt-get update
sudo apt-get install -y git clang libicu-dev

export SWIFT_VERSION="swift-3.0"

eval "$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)"

echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> .profile
echo 'export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"' >> .profile
