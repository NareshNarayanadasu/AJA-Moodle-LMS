FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libzip-dev unzip \
    mariadb-client git curl

RUN docker-php-ext-install mysqli pdo pdo_mysql zip gd intl soap exif opcache

RUN a2enmod rewrite

COPY php.ini /usr/local/etc/php/php.ini
