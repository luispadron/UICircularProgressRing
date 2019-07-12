#!/bin/bash

# Installs the SwiftLint package.
# Tries to get the precompiled .pkg file from Github, but if that
# fails just recompiles from source.

set -e

swift package generate-xcodeproj
swiftlint
bundle exec fastlane ios test
