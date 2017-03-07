#!/usr/bin/env bash

swift build -c release && ./.build/release/benchmark "$@"
