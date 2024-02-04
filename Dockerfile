FROM php:8.3.2-apache-bookworm as builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        libssl-dev \
        libgmp-dev \
        unzip \
        gcc make \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

FROM builder as phpext
RUN docker-php-ext-configure gmp \
    && docker-php-ext-install \
        ctype \ 
        curl \
        filter \ 
        pdo \
        session \ 
        xml \
        gmp
COPY --from=composer /usr/bin/composer /usr/bin/composer

FROM phpext as apache
RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ && \
    cp /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ && \
    cp /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ && \
    cp /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/
RUN echo "Mutex posixsem" >> /etc/apache2/apache2.conf
COPY httpd/apache.conf /etc/apache2/conf-enabled/vhost.conf

# php.ini設定を上書きする場合
#FROM apache as phpconf
#COPY php/php.ini-development $PHP_INI_DIR/php.ini