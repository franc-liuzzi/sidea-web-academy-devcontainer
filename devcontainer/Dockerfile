# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.1, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.1-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.1-buster, 8.0-buster, 7-buster, 7.4-buster
ARG PHP_VERSION=8-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${PHP_VERSION}

ARG MYSQL_HOST=db
ARG MYSQL_PORT=3306
ARG MYSQL_USER=mariadb
ARG MYSQL_PWD=mariadb

# Install MariaDB client
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-client gettext-base libonig-dev sudo \ 
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install php-mysql driver
RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring bcmath

# Setup mysql default connection
COPY ./app/my.cnf.template /tmp/
RUN envsubst < /tmp/my.cnf.template >> /etc/mysql/my.cnf

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN echo "\n" >> /home/vscode/.bashrc

# [Optional] Uncomment this section to install laravel/installer
RUN sudo -u vscode composer global require laravel/installer
RUN echo export PATH=~/.composer/vendor/bin:\$PATH >> /home/vscode/.bashrc

COPY ./app/cli-banner /home/vscode/.cli-banner
COPY ./app/cli-info.template /tmp
RUN envsubst < /tmp/cli-info.template >> /home/vscode/.cli-banner
RUN echo cat \$HOME/.cli-banner >> /home/vscode/.bashrc

WORKDIR /workspace
