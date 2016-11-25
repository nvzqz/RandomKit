#!/usr/bin/env bash -e

swift build -c release

./.build/release/benchmark "$@"
