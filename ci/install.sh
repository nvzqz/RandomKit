#!/usr/bin/env bash

set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    if [[ ! -d "$SWIFTENV_ROOT" ]]; then
        git clone https://github.com/kylef/swiftenv.git "$SWIFTENV_ROOT"
    fi

    for version in $SWIFT_VERSIONS; do
        if ! swiftenv global $version;
            then swiftenv install "$version"
        fi
    done
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    gem install xcpretty -N
fi
