FROM php:8.4-fpm
LABEL org.opencontainers.image.authors="alberto.contreras@thisisgain.com"

ARG TARGETPLATFORM

# Install dependencies, GD, zip, bcmath, and Python 2.7 in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    less groff jq git curl rsync ssh \
    python3 python3-pip \
    zip unzip libzip-dev \
    gnupg2 ca-certificates xdg-utils \
    libjpeg-dev libpng-dev libjpeg62-turbo libfreetype6-dev && \
  docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd zip bcmath && \
  echo "deb http://archive.debian.org/debian/ stretch main" > /etc/apt/sources.list.d/stretch.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends python2.7 && \
  rm /etc/apt/sources.list.d/stretch.list && \
  ln -s /usr/bin/python2.7 /usr/bin/python2 && \
  ln -s /usr/bin/python3 /usr/bin/python && \
  apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* && \
  echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Install NVM, Node.js and NPM
ENV NVM_DIR=/usr/local/.nvm
ARG DEFAULT_NODE_VERSION=20.18.1
ENV NODE_VERSION=${DEFAULT_NODE_VERSION}

RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    nvm cache clear

# Copy the Node.js version switching script
COPY node-version-switch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/node-version-switch.sh

# Add NVM to system profile and source the version switching script
RUN echo "export NVM_DIR=\"$NVM_DIR\"" >> /etc/bash.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/bash.bashrc && \
    echo '[ -f /usr/local/bin/node-version-switch.sh ] && . /usr/local/bin/node-version-switch.sh' >> /etc/bash.bashrc

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install AWS CLI v2, EB CLI, Ansible, CDK, Amplify, Composer, Acquia CLI
RUN case $TARGETPLATFORM in \
  linux/amd64) curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip ;; \
  linux/arm64) curl -s https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o awscliv2.zip ;; \
  *) echo "unsupported architecture"; exit 1 ;; \
esac && \
  unzip -q awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws && \
  apt-get update && apt-get install -y --no-install-recommends python3-virtualenv && \
  git clone --depth 1 https://github.com/aws/aws-elastic-beanstalk-cli-setup.git && \
  python3 ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py && \
  rm -rf aws-elastic-beanstalk-cli-setup && \
  apt-get purge -y --auto-remove python3-virtualenv && rm -rf /var/lib/apt/lists/* && \
  ln -s /root/.ebcli-virtual-env/executables/eb /usr/local/bin/eb && \
  pip3 install ansible-core --break-system-packages --no-cache-dir && \
  npm install -g aws-cdk @aws-amplify/cli && npm cache clean --force && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
  curl -sL https://github.com/acquia/cli/releases/latest/download/acli.phar -o /usr/local/bin/acli && \
  chmod +x /usr/local/bin/acli

ENV PATH=/usr/local:${PATH}
ENV COMPOSER_HOME='/usr/composer'

# Set directory and working permissions
WORKDIR /var/www
ENV PATH=/var/www/vendor/bin:${PATH}

# Set www-data user
RUN usermod -u 1000 www-data && \
   usermod -g users www-data && \
   chown -R www-data:www-data /var/www

# Copy and set entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
