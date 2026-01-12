#
FROM serversideup/php:8.3-fpm-nginx AS base

ARG NODE_VERSION=20
ARG NPM_VERSION=11

USER root

#install some base extensions
RUN set -eux \
	&& apt-get clean
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        iputils-ping \
        git \
        curl \
        wget \
        unzip \
        nano \
        vim \
        locales \
        pv \
        mariadb-client \
        ssl-cert \
        zlib1g-dev \
        libcap2-bin \
        libicu-dev \
        libbz2-dev \
        libxml2-dev \
        libxslt-dev \
        libpng-dev \
        libjpeg-dev \
        libmcrypt-dev

## Install decimal PHP extension.
#ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    gd \
    xdebug \
    calendar \
    exif \
    intl \
    mysqli \
    pdo_mysql \
    bcmath \
    bz2 \
    gettext \
    pcntl \
    soap \
    opcache


USER www-data

### Instaling composer / nodeJs / npm / yarn
#RUN export NODE_PATH=/usr/lib/node_modules
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer; \
#    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o /tmp/nodesource_setup.sh \
#    && bash /tmp/nodesource_setup.sh \
#    && apt-get install -y nodejs

FROM base AS dev
#
#ENV COMPOSER_MEMORY_LIMIT=-1
ARG USER_ID
ARG GROUP_ID
#
USER root

#update php.ini
#COPY php.local.ini "$PHP_INI_DIR/php.ini"
#update xdebug.ini
#COPY xdebug.ini "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

## Create user && Uncomment aliases
RUN useradd -u $USER_ID -m app -G www-data,root \
 && usermod -m -d /home/www-data www-data \
 && usermod -aG $GROUP_ID www-data \
 && sed -i '/alias l/s/^#//g' /home/app/.bashrc \
 && cp /home/app/.bashrc /home/www-data/

USER www-data




