#!/usr/bin/env bash

frameworkRestoreArgs() {
  _ARGUMENTS=(
    [0]='dump_file f "Target directory for dumps" true'
    [1]='zip zip "Use ZIP" false'
    [2]='host H "Database host server" false'
    [3]='port P "Database host port" false'
    [4]='database db "Database name" false'
    [5]='user u "Database username" false'
    [6]='password p "Database password" false'
  )
}

frameworkRestore() {

  # Conf contains site name / env and dump directory
  wex wexample/siteLoadConf -d=${DIR}

  # Get locally defined settings if not defined.
  if [[ -z "${HOST+x}" ]]; then
    HOST=${WEBSITE_SETTINGS_HOST}
  fi;

  if [[ -z "${PORT+x}" ]]; then
    PORT=${WEBSITE_SETTINGS_PORT}
  fi;

  if [[ -z "${DATABASE+x}" ]]; then
    DATABASE=${WEBSITE_SETTINGS_DATABASE}
  fi;

  if [[ -z "${USER+x}" ]]; then
    USER=${WEBSITE_SETTINGS_USERNAME}
  fi;

  if [[ -z "${PASSWORD+x}" ]]; then
    PASSWORD=${WEBSITE_SETTINGS_PASSWORD}
  fi;

  # Add -p option only if password is defined and not empty.
  # Adding empty password will prompt user instead.
  if [ "${PASSWORD}" != "" ]; then
    PASSWORD=-p"${PASSWORD}"
  fi;

  MYSQL_CONNEXION="mysql -h${HOST} -P${PORT} -u${USER} ${PASSWORD}"

  # Empty database
  ${MYSQL_CONNEXION} -e "DROP DATABASE IF EXISTS ${DATABASE}; CREATE DATABASE ${DATABASE};"

  # If file is a zip, unzip it.
  if [[ ${DUMP_FILE} =~ \.zip$ ]];then
     DUMP_FILE_BASE=${DUMP_FILE}
     DUMP_DIR=$(dirname  "${DUMP_FILE%.*}")
     DUMP_FILE=${DUMP_DIR}"/"$(basename  "${DUMP_FILE%.*}")
     unzip -oq ${DUMP_FILE} -d ${DUMP_DIR}
  fi;

  echo ${MYSQL_CONNEXION}

  # Create dump file
  ${MYSQL_CONNEXION} ${DATABASE} < ${DUMP_FILE}

  # If file was a zip, .sql file was temporary.
  if [[ ${DUMP_FILE_BASE} =~ \.zip$ ]];then
    rm ${DUMP_FILE}
  fi
}