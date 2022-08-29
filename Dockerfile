FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_VERSION 8.1

# Ensure this version of Ubuntu is fully up to date
RUN apt-get update && apt-get -y dist-upgrade

# Nginx packages
RUN apt-get install -y nginx nginx-extras

# PHP packages (version specific) \
RUN	apt -y install phpunit php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-cgi php${PHP_VERSION}-common php${PHP_VERSION}-dev php${PHP_VERSION}-common

# Clean up any unnecessary packages
RUN apt autoremove -y

## PHP Composer
RUN \
	cd /var/www && \
	curl --silent --show-error https://getcomposer.org/installer | php && \
	php${PHP_VERSION} composer.phar require

# Copy local files
COPY etc/ /etc/
COPY bin/ /usr/local/bin/

# Create PHP startup script
RUN \
	echo "" > /usr/local/bin/start-php && \
	echo "#!/bin/bash" >> /usr/local/bin/start-php && \
	echo "service php${PHP_VERSION}-fpm start" >> /usr/local/bin/start-php

# Fix for PHP to start up with link to correct socket for this version
RUN ln -s /run/php/php${PHP_VERSION}-fpm.sock /run/php-fpm.sock

WORKDIR /var/www/project
ENTRYPOINT /bin/bash /usr/local/bin/entry.sh
