FROM thisisgain/php:8.3.21-fpm

## Install required packages.
RUN apt-get update && apt-get install -y curl

## Install New Relic PHP agent
RUN curl -L https://download.newrelic.com/php_agent/archive/10.21.0.11/newrelic-php5-10.21.0.11-linux.tar.gz -o /tmp/newrelic.tar.gz && \
    tar -xzf /tmp/newrelic.tar.gz -C /tmp && \
    cd /tmp/newrelic-php5-* && \
    ./newrelic-install install && \
    rm -rf /tmp/newrelic*

## Copy New Relic configuration
COPY newrelic.ini /usr/local/etc/php/conf.d/newrelic.ini

