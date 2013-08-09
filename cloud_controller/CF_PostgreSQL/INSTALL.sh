#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# Installing PostgreSQL client ang gem

apt-get install postgresql-client postgresql-devel libpq-dev make -y

apt-get install ruby -y

gem install pg

# Installing PostgreSQL server

apt-get install postgresql -y


PG_CONF="/etc/postgresql/9.1/main/postgresql.conf"
sed -i "/ssl = /s/true/off/g" $PG_CONF


service postgresql restart
