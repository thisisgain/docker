ARG PHP_VERSION=latest
FROM thisisgain/php:${PHP_VERSION}

# Pinned release of the tideways_xhprof extension. It is NOT on PECL and must be
# built from source (https://github.com/tideways/php-xhprof-extension).
ARG TIDEWAYS_XHPROF_VERSION=v5.0.4

# Dev-only profiling/debugging extensions (NOT included in the production image).
# - xdebug: step debugging + coverage (available on PECL)
# - tideways_xhprof: function-level profiler (time + memory) consumed via XHGui,
#   compiled from source at the pinned tag above.
RUN set -eux; \
    # $PHPIZE_DEPS provides the compiler/autotools; git fetches the source.
    apt-get update; \
    apt-get install -y --no-install-recommends $PHPIZE_DEPS git; \
    # xdebug from PECL
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    # tideways_xhprof from source
    git clone --depth 1 --branch "${TIDEWAYS_XHPROF_VERSION}" \
        https://github.com/tideways/php-xhprof-extension.git /tmp/tideways_xhprof; \
    cd /tmp/tideways_xhprof; \
    # v5.0.4's config.m4 has a --enable-developer-flags block that uses the
    # PHP_CHECK_GCC_ARG macro, which was removed from modern PHP build tooling
    # and breaks configure generation. We never enable those flags, so strip the
    # whole block (from its `if` guard to its closing `fi`) before building.
    sed -i '/if test "\$PHP_DEVELOPER_FLAGS" = "yes"; then/,/^    fi$/d' config.m4; \
    rm -f configure; \
    rm -rf autom4te.cache; \
    phpize; \
    ./configure; \
    make -j"$(nproc)"; \
    make install; \
    docker-php-ext-enable tideways_xhprof; \
    # clean up build deps and sources to keep the image lean
    cd /; \
    rm -rf /tmp/tideways_xhprof; \
    apt-get purge -y --auto-remove git; \
    rm -rf /var/lib/apt/lists/*
