#!/bin/bash
set -e

if [[ $# -eq 0 ]]; then
    make clean && make release
else
    # shellcheck disable=SC2068
    make "$@"
fi

# After build, copy output files to /output
mkdir -p /output

cp -v out/*.3dsx /output/ 2>/dev/null || true
cp -v out/*.cia /output/ 2>/dev/null || true
