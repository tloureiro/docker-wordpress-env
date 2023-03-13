FROM php:8-apache

RUN apt-get update
RUN apt-get install -y ssl-cert nano default-mysql-client libonig-dev less libzip-dev zip libpng-dev imagemagick libmagickwand-dev libmagickcore-dev

RUN pecl install imagick

RUN a2enmod ssl rewrite

RUN make-ssl-cert generate-default-snakeoil --force-overwrite
RUN docker-php-ext-configure intl
RUN docker-php-ext-install mbstring mysqli opcache pdo pdo_mysql zip gd intl
RUN docker-php-ext-enable imagick

# wp-cli
RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp
RUN alias wp='wp --allow-root'

# Add wp creation script
COPY createwp /usr/bin/createwp
RUN chmod +x /usr/bin/createwp

# Apache configs
RUN rm -f /etc/apache2/sites-enabled/*
VOLUME /etc/apache2/sites-enabled/

#Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
ADD config/xdebug.ini /usr/local/etc/php/conf.d/user-xdebug.ini

# prep init
COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh
ENTRYPOINT ["init.sh"]
CMD ["apache2-foreground"]