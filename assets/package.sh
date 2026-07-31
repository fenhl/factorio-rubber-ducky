#!/bin/sh

set -e

version=$(jq -r '.version' info.json)
rm -f rubber-ducky-fenhl_*.zip
git archive --prefix "rubber-ducky-fenhl_${version}/" -o "rubber-ducky-fenhl_${version}.zip" HEAD . ':!/assets'
