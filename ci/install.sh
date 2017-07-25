#!/usr/bin/env bash

set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    git clone https://github.com/kylef/swiftenv.git "$SWIFTENV_ROOT"
    swiftenv install "$SWIFT_VERSION"
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    gem install xcpretty -N
fi
