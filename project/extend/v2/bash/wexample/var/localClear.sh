#!/usr/bin/env bash

varLocalClearArgs() {
  _ARGUMENTS=(
    [0]='name n "Variable name" true'
    [1]='file f "Storage file path" false'
    [2]='save_default s "Clear also last choice" false'
  )
}

varLocalClear() {
  # Remove all previous values.
  wex default::var/localClear -n="${NAME}" -f=./tmp/variablesLocalStorage

  if [ "${SAVE_DEFAULT}" == true ];then
    wex default::var/localClear -n="LAST_${NAME}"
  fi
}
