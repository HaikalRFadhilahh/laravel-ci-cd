# Install Package Node Js
FROM node:latest as node-build

# Setting Working Directory
WORKDIR /var/www/html

# Copy Source Code
COPY . .

# Install Depencies Node JS
RUN npm install

# Build Css
RUN npm run build

# PHP Apache Docker For Running And Composer
FROM php:apache-bullseye

# Update and Upgrade Repository Php
RUN apt-get update && apt-get install -y \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libxml2-dev \
    zlib1g-dev \
    libpng-dev \
    unzip \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Docker Ext
RUN docker-php-ext-install \
    bcmath \
    gd \
    curl\
    mbstring\
    mysqli\
    xml\
    zip \
    pdo \
    pdo_mysql

# Installing Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Setting Workingdir
WORKDIR /var/www/html

# Activate Rewrite .htaccess
RUN a2enmod rewrite

# Copy Source Code
COPY --from=node-build /var/www/html .

# Copy Configuration
COPY ./httpd/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Install Depencies
RUN composer install

# Optional Config Laravel
RUN php artisan storage:link

# Change User
RUN chown -R www-data:www-data /var/www/html

# Environtment Variable
ENV APP_NAME=Laravel
ENV APP_ENV=local
ENV APP_KEY=
ENV APP_DEBUG=true
ENV APP_TIMEZONE=UTC
ENV APP_URL=http://localhost

ENV APP_LOCALE=en
ENV APP_FALLBACK_LOCALE=en
ENV APP_FAKER_LOCALE=en_US

ENV APP_MAINTENANCE_DRIVER=file
ENV APP_MAINTENANCE_STORE=database

ENV BCRYPT_ROUNDS=12

ENV LOG_CHANNEL=stack
ENV LOG_STACK=single
ENV LOG_DEPRECATIONS_CHANNEL=null
ENV LOG_LEVEL=debug

ENV # Production Connection
ENV DB_CONNECTION=mysql
ENV DB_HOST=127.0.0.1
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=root
ENV DB_PASSWORD=

ENV SESSION_DRIVER=database
ENV SESSION_LIFETIME=120
ENV SESSION_ENCRYPT=false
ENV SESSION_PATH=/
ENV SESSION_DOMAIN=null

ENV BROADCAST_CONNECTION=log
ENV FILESYSTEM_DISK=local
ENV QUEUE_CONNECTION=database

ENV CACHE_STORE=database
ENV CACHE_PREFIX=

ENV MEMCACHED_HOST=127.0.0.1

ENV REDIS_CLIENT=phpredis
ENV REDIS_HOST=127.0.0.1
ENV REDIS_PASSWORD=null
ENV REDIS_PORT=6379

ENV MAIL_MAILER=log
ENV MAIL_HOST=127.0.0.1
ENV MAIL_PORT=2525
ENV MAIL_USERNAME=null
ENV MAIL_PASSWORD=null
ENV MAIL_ENCRYPTION=null
ENV MAIL_FROM_ADDRESS="hello@example.com"
ENV MAIL_FROM_NAME="${APP_NAME}"

ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_BUCKET=
ENV AWS_USE_PATH_STYLE_ENDPOINT=false

ENV VITE_APP_NAME="${APP_NAME}"

ENV ASSET_URL=http://127.0.0.1

# Expose Port
EXPOSE 80
