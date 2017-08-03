#!/usr/bin/env bash

set -e -o pipefail

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    swiftenv version
    swift test
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    xcodebuild -version
    xcodebuild -showsdks

    function build() {
        if $3; then
            XC_CMD="test"
        else
            XC_CMD="build"
        fi
        for cfg in Debug Release; do
            xcodebuild \
                -project $FRAMEWORK_NAME.xcodeproj \
                -scheme "$FRAMEWORK_NAME $1" \
                -destination "$2" \
                -configuration "$cfg" \
                ONLY_ACTIVE_ARCH=NO \
                $XC_CMD | xcpretty
        done
    }

    # ----- OS: --- Destination: ---------------------- Tests:
    build   macOS   "arch=x86_64"                       true
    build   iOS     "OS=8.1,name=iPhone 4S"             true
    build   tvOS    "OS=9.0,name=Apple TV 1080p"        true
    build   watchOS "OS=2.0,name=Apple Watch - 42mm"    false

    if $QUICK_POD_LINT; then
        QUICK_ARG="--quick"
    else
        pod repo list
        pod repo update
    fi

    pod lib lint --allow-warnings $QUICK_ARG
fi
