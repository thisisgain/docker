FROM php:8.4.12-fpm

ARG TARGETPLATFORM

# Supported architectures.
RUN case $TARGETPLATFORM in \
  linux/amd64) LIBDIR='x86_64-linux-gnu';; \
  linux/arm64) LIBDIR='aarch64-linux-gnu';; \
  *) echo "unsupported architecture"; exit 1 ;; \
esac

# install default PHP extensions
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libonig-dev libzip-dev libpq-dev libldap2-dev libbz2-dev default-mysql-client rsyslog imagemagick libwebp-dev webp libmagickwand-dev openssh-client \
  && docker-php-ext-configure gd --with-jpeg --with-webp \
  && docker-php-ext-configure ldap --with-libdir=lib/$LIBDIR/ \
  && docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip ldap bz2

# Install soap client.
RUN apt-get install libxml2-dev -y \
  && docker-php-ext-install soap

# Install BCMath
RUN docker-php-ext-install bcmath

## Install necessary libraries
RUN apt-get install libmemcached-dev -y \
  && pecl install memcached \
  && docker-php-ext-enable memcached

# Install imagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=60'; \
  echo 'opcache.fast_shutdown=1'; \
  echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install New Relic PHP agent via package manager
RUN curl -L https://download.newrelic.com/php_agent/archive/12.1.0.26/newrelic-php5-12.1.0.26-linux.tar.gz | tar -C /tmp -zx \
    && export NR_INSTALL_USE_CP_NOT_LN=1 \
    && export NR_INSTALL_SILENT=1 \
    && /tmp/newrelic-php5-*/newrelic-install install

# Copy template and entrypoint
COPY newrelic.ini.template /newrelic/newrelic.ini.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Create CMD start file
RUN { \
  echo '#!/bin/bash'; \
  echo 'rsyslogd'; \
  echo 'php-fpm'; \
} > /php-fpm.sh
RUN chmod +x /php-fpm.sh

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Configure www-data user
RUN usermod -u 33 www-data \
  && usermod -a -G users www-data \
  && usermod -d /root www-data

# Set up bash
COPY ./.bashrc /root/.bashrc

# Set up working directory
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www

# Add project composer bin to PATH
ENV PATH=$PATH:/var/www/html/vendor/bin

# Start services
CMD ["/php-fpm.sh"]
