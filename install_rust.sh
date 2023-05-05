#!/usr/bin/env bash

# install rust compiler

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash

install_rust
