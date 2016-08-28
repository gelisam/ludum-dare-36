#!/bin/bash
set -e

./rebuild.sh
fswatcher --path src --throttle=300 ./rebuild.sh
