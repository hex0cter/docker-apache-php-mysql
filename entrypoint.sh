#!/bin/bash

mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && usermod -d /var/lib/mysql/ mysql
service mysql start
mysql -u root < create-user.sql

# apache2 -DFOREGROUND
bash
