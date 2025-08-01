#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y mysql-server

sed -i "s/^bind-address.*/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'192.168.56.%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
