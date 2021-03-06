#!/usr/bin/env bash

wordpressChangeCoreArgs() {
  _DESCRIPTION="Replace WP core with another version, useful for downgrading. Let user to update database from admin."
  _ARGUMENTS=(
    [0]='version v "Wordpress destination version number (ex: 4.9.5)" true'
  )
}

wordpressChangeCore() {
  local FILENAME='wordpress-'${VERSION}'.zip'
  # Download last version.
  wex site/exec -c="cd /var/www && rm -rf wordpress && rm -rf ${FILENAME} && wget https://wordpress.org/${FILENAME} && unzip ${FILENAME} && rm ${FILENAME}"
  # Remove old files.
  wex site/exec -l -c="rm -rf ./wp-includes && rm -rf ./wp-admin"
  # Copy new
  wex site/exec -c="cp -r /var/www/wordpress/wp-includes /var/www/html/project"
  wex site/exec -c="cp -r /var/www/wordpress/wp-admin /var/www/html/project"
  # Copy without removing existing.
  wex site/exec -c="cp -r /var/www/wordpress/wp-content /var/www/html/project"
  # Copy root files, omit directories.
  wex site/exec -c="cp /var/www/wordpress/* /var/www/html/project" | grep -v 'omitting directory'
  # Now user should visit wp-admin for database migration or run wp cli update
}