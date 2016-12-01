#!/bin/sh
set -eux

echo "*** Installing MySQL"
apk add --update --no-cache mysql
mysql_install_db --user=mysql --basedir=/usr/ --datadir=/mysql/data --force
chown -R mysql /mysql
# change default run path to the work dir
sed -i -e"s~/run/mysqld~/mysql~g" -e 's/#.*$//' -e '/^$/d' /etc/mysql/my.cnf