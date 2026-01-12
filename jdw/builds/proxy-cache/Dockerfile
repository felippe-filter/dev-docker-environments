# proxy-cache
# php8.3 - xdebug - apache - node
FROM php:8.3-apache AS base

ARG NODE_VERSION=20
ARG NPM_VERSION=11

#install some base extensions
RUN set -eux \
	&& apt-get clean
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        curl \
        git \
        iputils-ping \
        jq \
        libbz2-dev \
        libcap2-bin \
        libcurl4-openssl-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libonig-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        locales \
        nano \
        pv \
        ssl-cert \
        unzip \
        vim \
        wget \
        zip \
        zlib1g-dev

## Install decimal PHP extension.
#ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    curl \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    zip

RUN pecl install redis mcrypt-1.0.6 xdebug \
    && docker-php-ext-enable \
        redis \
        xdebug \
        opcache

## Instaling composer / nodeJs / npm / yarn
RUN export NODE_PATH=/usr/lib/node_modules \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o /tmp/nodesource_setup.sh \
    && bash /tmp/nodesource_setup.sh \
    && apt-get install -y nodejs \
    && npm install --global npm@${NPM_VERSION}\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM base AS dev

#ENV COMPOSER_MEMORY_LIMIT=-1
ARG USER_ID
ARG GROUP_ID

RUN mkdir /etc/apache2/sites-available/ssl \
    && mkdir -m 775 -p /.cache

#update php.ini
COPY php.local.ini "$PHP_INI_DIR/php.ini"
#update xdebug.ini
COPY xdebug.ini "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

COPY ssl /etc/apache2/sites-available/ssl/
# Copy the custom Apache virtual host config
COPY httpd.conf "/etc/apache2/sites-available/100-default.conf"

# Enable SSL module, configure Apache for PHP support, and enable our SSL site configuration
RUN a2enmod ssl rewrite && \
    a2dissite 000-default default-ssl && \
    a2ensite 100-default

# Create user && Uncomment aliases
RUN useradd -u $USER_ID -m app \
 && sed -i '/alias l/s/^#//g' /home/app/.bashrc \
 && sed -i '/alias l/s/^#//g' /root/.bashrc

USER app
WORKDIR /app




