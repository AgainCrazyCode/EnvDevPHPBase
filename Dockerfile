FROM php:7.1-fpm-alpine
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apk --update add ca-certificates && \
    echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache $PHPIZE_DEPS && \
    apk add -U \
        libwebp@edge-main \
        php7-openssl@edge-main \
        php7-dba@edge-community \
        php7-sqlite3@edge-community \
        php7-pear@edge-community \
        php7-tokenizer@edge-community \
        php7-phpdbg@edge-community \
        cacti-php7@edge-community \
        xapian-bindings-php7@edge-community \
        php7-litespeed@edge-community \
        php7-gmp@edge-community \
        php7-pdo_mysql@edge-community \
        php7-pcntl@edge-community \
        php7-common@edge-community \
        php7-xsl@edge-community \
        php7-fpm@edge-community \
        php7-mysqlnd@edge-community \
        php7-enchant@edge-community \
        php7-pspell@edge-community \
        php7-redis@edge-community \
        php7-snmp@edge-community \
        php7-doc@edge-community \
        php7-fileinfo@edge-community \
        php7-mbstring@edge-community \
        php7-dev@edge-community \
        php7-pear-mail_mime@edge-community \
        php7-xmlrpc@edge-community \
        php7-embed@edge-community \
        php7-xmlreader@edge-community \
        php7-pear-mdb2_driver_mysql@edge-community \
        php7-pdo_sqlite@edge-community \
        php7-pear-auth_sasl2@edge-community \
        php7-exif@edge-community \
        php7-recode@edge-community \
        php7-opcache@edge-community \
        php7-ldap@edge-community \
        php7-posix@edge-community \
        php7-pear-net_socket@edge-community \
        php7-session@edge-community \
        php7-gd@edge-community \
        php7-gettext@edge-community \
        php7-mailparse@edge-community \
        php7-json@edge-community \
        php7-xml@edge-community \
        php7@edge-community \
        php7-iconv@edge-community \
        php7-sysvshm@edge-community \
        php7-curl@edge-community \
        php7-shmop@edge-community \
        php7-odbc@edge-community \
        php7-phar@edge-community \
        php7-pdo_pgsql@edge-community \
        php7-imap@edge-community \
        php7-pear-mdb2_driver_pgsql@edge-community \
        php7-pdo_dblib@edge-community \
        php7-pgsql@edge-community \
        php7-pdo_odbc@edge-community \
        php7-xdebug@edge-community \
        php7-zip@edge-community \
        php7-apache2@edge-community \
        php7-cgi@edge-community \
        php7-ctype@edge-community \
        php7-mcrypt@edge-community \
        php7-wddx@edge-community \
        php7-pear-net_smtp@edge-community \
        php7-bcmath@edge-community \
        php7-calendar@edge-community \
        php7-tidy@edge-community \
        php7-dom@edge-community \
        php7-sockets@edge-community \
        php7-zmq@edge-community \
        php7-memcached@edge-community \
        php7-soap@edge-community \
        php7-apcu@edge-community \
        php7-sysvmsg@edge-community \
        php7-zlib@edge-community \
        php7-ftp@edge-community \
        php7-sysvsem@edge-community \
        php7-pdo@edge-community \
        php7-pear-auth_sasl@edge-community \
        php7-bz2@edge-community \
        php7-mysqli@edge-community \
        php7-pear-net_smtp-doc@edge-community \
        php7-simplexml@edge-community \
        php7-xmlwriter@edge-community \
        ssmtp \
        shadow@edge-community \
        curl \
        libuv@edge-main \
        nodejs@edge-main \
        nodejs-npm@edge-main \
        git \
        composer@edge-community \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && rm -rf /var/cache/apk/*

# # set up sendmail config
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=vincent.falies@wolterskluwer.com" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# # Set up php sendmail config
RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost localhost.localdomain" >> /etc/hosts

# Set up XDebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /var/www/html

# User creation
RUN useradd -U -m -r -o -u 1003 vfac

# install fixuid
RUN USER=vfac && \
    GROUP=vfac && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.3/fixuid-0.3-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

ENTRYPOINT ["fixuid"]

USER vfac:vfac
RUN composer config --global repo.packagist composer https://packagist.org

CMD ["php-fpm"]