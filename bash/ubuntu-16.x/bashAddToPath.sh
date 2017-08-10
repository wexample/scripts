#!/usr/bin/env bash

bashAddToPath() {
  if [[ ":$PATH:" != *":${1}"* ]]; then
    # Add now.
    export PATH=$PATH:"${1}"
    # Add to path.
    bash ${WEX_DIR_ROOT}'wexample.sh' fileTextAppend ~/.bashrc 'export PATH=$PATH:'${1}
  fi
}