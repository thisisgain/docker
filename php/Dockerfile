FROM php:8.4.25-fpm

ARG TARGETPLATFORM

# Install PHP extensions and clean up build deps in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg-dev libonig-dev libzip-dev libpq-dev libldap2-dev \
    libbz2-dev libwebp-dev libmagickwand-dev libmemcached-dev libxml2-dev \
    default-mysql-client rsyslog imagemagick openssh-client webp && \
  LIBDIR=$(case $TARGETPLATFORM in \
    linux/amd64) echo 'x86_64-linux-gnu';; \
    linux/arm64) echo 'aarch64-linux-gnu';; \
    *) dpkg-architecture -qDEB_HOST_MULTIARCH;; \
  esac) && \
  docker-php-ext-configure gd --with-jpeg --with-webp && \
  docker-php-ext-configure ldap --with-libdir=lib/$LIBDIR/ && \
  docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip ldap bz2 soap bcmath && \
  pecl install memcached imagick && \
  docker-php-ext-enable memcached imagick && \
  apt-get purge -y libpng-dev libjpeg-dev libmagickwand-dev && \
  apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/pear

# set recommended opcache settings
RUN { \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=60'; \
  echo 'opcache.fast_shutdown=1'; \
  echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Create CMD start file
RUN printf '#!/bin/bash\nrsyslogd\nphp-fpm\n' > /php-fpm.sh && chmod +x /php-fpm.sh

# Configure www-data user
RUN usermod -u 33 www-data && \
    usermod -a -G users www-data && \
    usermod -d /root www-data

# Copy entrypoint and bashrc
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./.bashrc /root/.bashrc

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www

ENV PATH=$PATH:/var/www/html/vendor/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/php-fpm.sh"]
