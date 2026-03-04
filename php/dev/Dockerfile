ARG PHP_VERSION=latest
FROM thisisgain/php:${PHP_VERSION}

# Install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
