#!/usr/bin/env bash

siteStartedArgs() {
  _ARGUMENTS=(
    [0]='dir_site d "Root site directory" false'
  )
}

siteStarted() {
  if [ -z "${DIR_SITE+x}" ]; then
    DIR_SITE=./
  fi;

  # Config file exists
  if [[ -f ${DIR_SITE}tmp/config ]];then
    . ${DIR_SITE}tmp/config
    echo $([[ ${STARTED} == true ]] && echo true || echo false)
  fi
}
