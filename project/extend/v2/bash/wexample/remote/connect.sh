#!/usr/bin/env bash

remoteConnectArgs() {
  _ARGUMENTS=(
    [0]='ssh_user_custom u "SSH User" false'
    [1]='ssh_private_key_custom k "SSH Private key" false'
    [2]='ssh_host_custom h "Host to connect to" false'
    [3]='ssh_port_custom p "SSH Port" false'
    [4]='environment e "Environment to connect to" true'
  )
}

remoteConnect() {
  wex remote/init -e=${ENVIRONMENT}
  # Prevent to set credentials globally
  local SSH_CONNEXION=$(wex remote/connexion -e=${ENVIRONMENT} ${WEX_ARGUMENTS})
  ssh -oStrictHostKeyChecking=no ${SSH_CONNEXION}
}
