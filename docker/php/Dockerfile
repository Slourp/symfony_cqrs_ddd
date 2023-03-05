FROM php:8.2-fpm-alpine

ARG USER_ID
ARG GROUP_ID
ARG USER

RUN apk add --update linux-headers

RUN apk add bash git --no-cache mysql-client msmtp perl wget procps shadow libzip libpng libjpeg-turbo libwebp freetype icu gd

RUN apk add --no-cache --virtual build-essentials \
    icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install intl && \
    docker-php-ext-install opcache && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip && \
    apk del build-essentials && rm -rf /usr/src/php*


RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug


# Set Higher php memory size
# RUN cd /usr/local/etc/php/conf.d/ && \
#     echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

# INSTALL COMPOSER 
COPY --from=composer /usr/bin/composer /usr/bin/composer


# Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Create a group and user
RUN addgroup -g ${GROUP_ID} -S ${USER} && adduser -u ${USER_ID}  -S ${USER} -G ${USER} 

# Tell docker that all future commands should run as the appuser user
USER ${USER}

RUN git config --global user.email "vanmakdavid@pop-france.eu" \ 
    && git config --global user.name "David VANMAK"

WORKDIR "/var/www/app"
