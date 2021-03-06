# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.1, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.1-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.1-buster, 8.0-buster, 7-buster, 7.4-buster
ARG PHP_VERSION=8.1
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${PHP_VERSION}

# Install MariaDB client
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-client gettext-base libonig-dev sudo \ 
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install php-mysql driver
RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring bcmath

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="lts/gallium"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN umask 0002 \
    && . /usr/local/share/nvm/nvm.sh \
    && npm install -g @angular/cli serverless @nestjs/cli ts-node typescript @babel/core @babel/node

# install aws-cli
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

ARG MYSQL_HOST=db
ARG MYSQL_PORT=3306
ARG MYSQL_USER=mariadb
ARG MYSQL_PWD=mariadb
ARG MYSQL_ROOT_PWD=mariadb
ARG MYSQL_DB_NAME=mariadb

# Setup mysql default connection
COPY ./app/mysql/my.cnf.template /tmp/
RUN envsubst < /tmp/my.cnf.template >> /etc/mysql/my.cnf

# fix xdebug.ini
COPY ./app/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# set user
USER vscode

RUN echo "\n" >> ~/.bashrc
RUN mkdir -p ~/.local/bin

#  install laravel/installer
RUN composer global require laravel/installer
RUN echo export PATH=~/.composer/vendor/bin:\$PATH >> ~/.bashrc

RUN cd /tmp

# install exercism cli
RUN wget --quiet https://github.com/exercism/cli/releases/download/v3.0.13/exercism-linux-64bit.tgz \
    && tar xf exercism-linux-64bit.tgz \
    && mv exercism ~/.local/bin \
    && mkdir -p ~/.exercism ~/.config/exercism/ \
    && mv shell/exercism_completion.bash ~/.exercism/exercism_completion.bash \
    && echo "if [ -f ~/.exercism/exercism_completion.bash ]; then source ~/.exercism/exercism_completion.bash; fi" >> ~/.bashrc
ADD --chown=vscode:vscode ./app/exercism/user.json /home/vscode/.config/exercism/
# persisting exercism configuration
VOLUME [ "/home/vscode/.config/exercism" ]

# setup sidea devcontainer info
ARG SIDEA_DEVCONTAINER_VERSION
ENV SIDEA_DEVCONTAINER_VERSION=${SIDEA_DEVCONTAINER_VERSION}
COPY ./app/sidea-devcontainer/sidea-devcontainer-info.template.sh /tmp
RUN envsubst < /tmp/sidea-devcontainer-info.template.sh >> ~/.local/bin/sidea-devcontainer-info \
    && chmod +x ~/.local/bin/sidea-devcontainer-info \
    && echo sidea-devcontainer-info >> ~/.bashrc

COPY --chown=vscode:vscode ./app/sidea-devcontainer/sidea-devcontainer-update.sh /home/vscode/.local/bin/sidea-devcontainer-update

# cleanup
RUN sudo rm -rf /tmp/*

WORKDIR /workspace
