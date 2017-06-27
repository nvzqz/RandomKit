#!/usr/bin/env bash

set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    export SWIFTENV_ROOT="$HOME/.swiftenv"
    git clone https://github.com/kylef/swiftenv.git "$SWIFTENV_ROOT"
    export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"

    echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bash_profile
    echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(swiftenv init -)"' >> ~/.bash_profile

    for version in $SWIFT_VERSIONS; do
        swiftenv install "$version"
    done
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    gem install xcpretty -N
fi
