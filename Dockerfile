FROM php:apache

RUN apt-get update
RUN apt-get install -y ssl-cert nano mysql-client less

RUN a2enmod ssl
RUN a2ensite default-ssl

RUN make-ssl-cert generate-default-snakeoil --force-overwrite
RUN docker-php-ext-install json mbstring mysqli opcache pdo pdo_mysql

# wp-cli
RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp
RUN alias wp='wp --allow-root'

# Add wp creation script
COPY createwp /usr/bin/createwp
RUN chmod +x /usr/bin/createwp