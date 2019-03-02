#!/bin/sh
set -eux

echo "*** Installing MySQL"
apk add --update --no-cache mysql
mysql_install_db --user=mysql --basedir=/usr/ --datadir=/mysql/data --force
mkdir -p /run/mysqld/
chown -R mysql /mysql /run/mysqld/
