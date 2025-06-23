FROM thisisgain/php:8.3.21-fpm

# Install New Relic PHP agent via package manager
RUN curl -L https://download.newrelic.com/php_agent/release/newrelic-php5-11.9.0.23-linux.tar.gz | tar -C /tmp -zx \
    && export NR_INSTALL_USE_CP_NOT_LN=1 \
    && export NR_INSTALL_SILENT=1 \
    && /tmp/newrelic-php5-*/newrelic-install install

# Copy template and entrypoint
COPY ../newrelic.ini.template /newrelic/newrelic.ini.template
COPY ../entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
