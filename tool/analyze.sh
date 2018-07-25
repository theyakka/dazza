#!/bin/bash

set -e

echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS lib test

echo "Checking dartfmt..."
if [[ $(dartfmt -n --set-exit-if-changed lib test) ]]; then
	echo "Failed dartfmt check: run dartfmt -w lib/ test/"
	exit 1
fi