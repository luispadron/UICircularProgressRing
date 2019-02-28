#!/bin/bash

rm -rf src/Carthage
carthage build --project-directory src/ --no-skip-current
carthage archive --project-directory src/ --output .
