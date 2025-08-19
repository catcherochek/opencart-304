FROM php:8.2-fpm-alpine

# Base tools + build deps
RUN apk add --no-cache bash nginx supervisor curl \
    icu-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev \
    libxml2-dev oniguruma-dev

# PHP extensions needed by OpenCart
RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
 && docker-php-ext-install -j$(nproc) gd intl zip mysqli pdo_mysql opcache mbstring bcmath

# Nginx folders
RUN mkdir -p /run/nginx /var/cache/nginx /var/log/nginx

# Make sure php-fpm can run in foreground and listen on 9000 (default)
# (No change needed; php-fpm in official image uses 127.0.0.1:9000)

# Copy configs (mounted in compose too; copying keeps image self-contained)
COPY docker/php/php.ini /usr/local/etc/php/conf.d/99-oc.ini
COPY docker/php/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/php/supervisord.conf /etc/supervisord.conf

# Workdir for app code
WORKDIR /var/www/html


EXPOSE 80

# Run both nginx and php-fpm under supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]