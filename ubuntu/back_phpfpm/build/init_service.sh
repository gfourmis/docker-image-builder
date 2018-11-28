#!/bin/bash

# Iniciar phpfpm
/etc/php7/sbin/php-fpm --fpm-config /etc/php7/etc/php-fpm.conf

# Iniciar apache2
./apache2ctl -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apache2ctl: $status"
  exit $status
fi