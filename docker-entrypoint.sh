#!/bin/bash
mv /apps/php-7.4.0/etc/php-fpm.conf.default /apps/php-7.4.0/etc/php-fpm.conf
mv /apps/php-7.4.0/etc/php-fpm.d/www.conf.default /apps/php-7.4.0/etc/php-fpm.d/www.conf
exec "$@"
