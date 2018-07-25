#!/bin/bash
set -e
PORT=92552

echo "Collecting coverage on port $PORT..."
dart \
    --enable-vm-service=$PORT \
    --pause-isolates-on-exit \
    test/test_all.dart &
pub run coverage:collect_coverage \
    --port=$PORT \
    --out=_coverage/coverage.json \
    --wait-paused \
    --resume-isolates

echo "Generating LCOV report..."
pub run coverage:format_coverage \
    --lcov \
    --in=_coverage/coverage.json \
    --out=_coverage/coverage.lcov \
    --packages=.packages \
    --report-on=lib