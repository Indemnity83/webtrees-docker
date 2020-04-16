FROM alpine

LABEL maintainer="Kyle Klaus <kklaus@indemnity83.com>"

ARG WEBTREES_VERSION=master
ENV UPLOAD_LIMIT=20M

# Install packages
RUN apk --no-cache add git nginx php php7-fpm php7-json php7-mbstring php7-iconv \
    php7-session php7-xml php7-curl php7-fileinfo php7-gd php7-intl php7-zip \
    php7-simplexml php7-pdo php7-sqlite3 php7-pdo_sqlite php7-exif php7-pdo_mysql \
    php7-pdo_pgsql php7-pdo_odbc supervisor

# Configure NGINX
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/log/php7 && \
  chown -R nobody.nobody /var/log/nginx && \
  chmod 0751 /var/lib/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
RUN git clone -c advice.detachedHead=false --depth=1 -b ${WEBTREES_VERSION} https://github.com/fisharebest/webtrees.git .

# Trim some fat
RUN rm -rf .git

# Expose the application
EXPOSE 8080
VOLUME /var/www/html/data/

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up & running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
