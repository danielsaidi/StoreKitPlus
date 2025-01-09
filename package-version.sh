#!/bin/bash

# Documentation:
# This script creates a new project version for the package.
# You can pass in a custom branch if you don't want to use the default one.

NAME="StoreKitPlus"
DEFAULT_BRANCH="main"
BRANCH=${1:-$DEFAULT_BRANCH}
SCRIPT="scripts/version.sh"
chmod +x $SCRIPT
bash $SCRIPT $NAME $BRANCH
