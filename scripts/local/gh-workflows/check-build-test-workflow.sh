#!/bin/bash

# source local vars
source ./scripts/local/local-vars.sh &&

# run act to test github workflow
# with current machine as self-host
# for yml jobs where runs-on == "macos-latest"

act -v \
	-W .github/workflows/spm-build-test.yml \
	-P macos-latest=-self-hosted