#!/bin/bash

cp -n /etc/apache2/sites-available/* /etc/apache2/sites-enabled/
chmod -R 777 /etc/apache2/sites-enabled/
chmod -R 777 /var/www/html/

exec "$@"