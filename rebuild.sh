#!/bin/bash
set -e
clear
elm-make src/Main.elm --output=generated/Main.js --warn
