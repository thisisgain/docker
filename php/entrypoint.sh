#!/bin/bash

# Generate newrelic.ini from template
cp /newrelic/newrelic.ini.template /usr/local/etc/php/conf.d/x-newrelic.ini

# Set newrelic enabled status (default: false)
NEWRELIC_ENABLE=${NEWRELIC_ENABLE:-false}
sed -i "s/newrelic.enabled=false/newrelic.enabled=$NEWRELIC_ENABLE/" /usr/local/etc/php/conf.d/x-newrelic.ini

# Set application name if provided
if [ -n "$NEWRELIC_APPLICATION" ]; then
    sed -i "s/APPNAME/$NEWRELIC_APPLICATION/" /usr/local/etc/php/conf.d/x-newrelic.ini
fi

# Set license key if provided
if [ -n "$NEWRELIC_KEY" ]; then
    sed -i "s/LICENSE/$NEWRELIC_KEY/" /usr/local/etc/php/conf.d/x-newrelic.ini
fi

# Set daemon address
if [ -n "$NEWRELIC_DAEMON_ADDRESS" ]; then
    sed -i "s/DAEMON_ADDRESS/$NEWRELIC_DAEMON_ADDRESS/" /usr/local/etc/php/conf.d/x-newrelic.ini
fi

# Execute the original command
exec "$@"