#!/usr/bin/env bash

letsEncryptInstall() {

  # TODO, work also with -d domain1.com -d domain2.com etc...
  EMAIL="contact@wexample.com"
  SITE_DOMAIN="wexample.com"
  SITE_DIR_ROOT="/var/www/html"

  # Install cert bot
  wget https://dl.eff.org/certbot-auto
  chmod a+x certbot-auto
  mv certbot-auto /usr/local/bin

  # Install the dependencies.
  certbot-auto --noninteractive --os-packages-only

  # Set up config file.
  mkdir -p /etc/letsencrypt

  # Set configuration
  CONF=/etc/letsencrypt/cli.ini
  cp ${WEX_DIR_BASH_UBUNTU16}"samples/letsEncrypt.cli.ini" ${CONF}

  wexample configChangeValue ${CONF} "email" "${EMAIL}" " = "
  wexample configChangeValue ${CONF} "domains" "${SITE_DOMAIN}, www.${SITE_DOMAIN}" " = "
  wexample configChangeValue ${CONF} "webroot-path" "${SITE_DIR_ROOT}" " = "

  # Install cron
  CRON_SCRIPT=/etc/cron.daily/certbot-renew
  cp ${WEX_DIR_BASH_UBUNTU16}"samples/letsEncrypt.cron.sh" ${CRON_SCRIPT}

  # Execute cron once (should send confirmation mail)
  . ${CRON_SCRIPT}
}