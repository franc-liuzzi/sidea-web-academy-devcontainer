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
ARG NODE_VERSION="lts/gallium"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN umask 0002 \
    && . /usr/local/share/nvm/nvm.sh \
    && npm install -g @angular/cli serverless @nestjs/cli

# install aws-cli
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# fix xdebug.ini
COPY ./app/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

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
    && mkdir -p ~/.config/exercism \
    && mv shell/exercism_completion.bash ~/.config/exercism/exercism_completion.bash \
    && echo "if [ -f ~/.config/exercism/exercism_completion.bash ]; then source ~/.config/exercism/exercism_completion.bash; fi" >> ~/.bashrc

# setup sidea banner and container info
COPY --chown=vscode:vscode ./app/cli-banner /home/vscode/.config/sideagroup/cli-banner
RUN ls -la && cat ~/.config/sideagroup/cli-banner
COPY ./app/cli-info.template /tmp
RUN envsubst < /tmp/cli-info.template >> ~/.config/sideagroup/cli-banner \
    && echo cat ~/.config/sideagroup/cli-banner >> ~/.bashrc

COPY ./app/devcontainer-update.sh /home/vscode/.local/bin/devcontainer-update

# cleanup
RUN sudo rm -rf /tmp/*

WORKDIR /workspace
