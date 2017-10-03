#!/bin/bash
mysqld --initialize-insecure --datadir=/var/lib/mysql

chown -R mysql:mysql /var/lib/mysql
service mysql start

mysql -e "SET @@SESSION.SQL_LOG_BIN=0;\
    DELETE FROM mysql.user WHERE user NOT IN ('mysql.sys', 'mysqlxsys', 'root') OR host NOT IN ('localhost');\
    SET PASSWORD FOR 'root'@'localhost'=PASSWORD('root');\
    CREATE USER 'sentry'@'localhost' IDENTIFIED BY 'sentry' PASSWORD EXPIRE NEVER;\
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;\
    GRANT ALL PRIVILEGES ON sentry.* TO 'sentry'@'localhost';\
    GRANT ALL PRIVILEGES ON sentry_tests.* TO 'sentry'@'localhost';\
    FLUSH PRIVILEGES ;"

mysql -usentry -psentry -e "CREATE DATABASE sentry;"
mysql -usentry -psentry sentry < /opt/cyclops/tests/sentry_db.sql

service mysql stop