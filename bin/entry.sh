#!/bin/bash

#/etc/init.d/php7.2-fpm start
service nginx start
/bin/bash /usr/local/bin/start-php

/bin/bash

# normal operations run Apache2 in foreground.
#/usr/sbin/apache2 start