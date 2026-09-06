ARG PHP_VERSION=latest
FROM thisisgain/php:${PHP_VERSION}

# Dev-only profiling/debugging extensions (NOT included in the production image).
# - xdebug: step debugging + coverage
# - tideways_xhprof: function-level profiler (time + memory) consumed via XHGui
RUN pecl install xdebug tideways_xhprof \
    && docker-php-ext-enable xdebug tideways_xhprof
