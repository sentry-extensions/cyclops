#!/bin/bash

if [ ! -f /var/lock/post-install ]; then
    bash /usr/bin/post-install.sh

    RESULT=$?
    if [ $RESULT -ne 0 ]; then
      exit $RESULT
    fi

    touch /var/lock/post-install
fi

service mysql start
/usr/local/bin/redis-server /etc/redis.conf

tail -F /var/log/mysql/error.log
