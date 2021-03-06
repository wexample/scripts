#!/usr/bin/env bash

mysqlStop() {
  . ${WEX_WEXAMPLE_SITE_CONFIG}

  _wexMessage "Free MySQL site.cnf access"

  docker exec ${SITE_NAME_INTERNAL}_mysql chmod 777 /var/www/tmp/mysql.cnf
  docker exec ${SITE_NAME_INTERNAL}_mysql chmod 777 /etc/mysql/conf.d/site.cnf
}
