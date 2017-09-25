#!/usr/bin/env bash

frameworkSettingsArgs() {
  _ARGUMENTS=(
    [0]='dir d "Root directory of framework" false'
  )
}

frameworkSettings() {
  # Detect type.
  websiteType=$(wex framework/detect -d=${DIR});
  # Get file path.
  settingsPath=$(wex framework/settingsPath -t=${websiteType})
  if [[ ${websiteType} != 'default' ]];then
    # Parse file.
    wex "framework"$(wexampleUpperCaseFirstLetter ${websiteType})'/settings' -d=${DIR}"/"${settingsPath}
  fi;
}