#!/bin/bash

carthage build src/ --no-skip-current
carthage archive --project-directory src/ --output .
