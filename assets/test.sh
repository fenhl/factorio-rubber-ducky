#!/bin/sh

set -e

rm -rf ~/.factorio/mods/rubber-ducky-fenhl
cp -R . ~/.factorio/mods/rubber-ducky-fenhl
factorio
