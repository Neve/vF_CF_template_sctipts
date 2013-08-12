#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# Installing PostgreSQL client ang gem

apt-get install postgresql-client libpq-dev make -y

echo "  Installing Ruby"
apt-get install ruby1.9.1 ruby1.9.1-dev -y
echo "  Installing PostgreSQL gem"
gem install pg --no-ri --no-rdoc

echo "  Installing PostgreSQL server"

apt-get install postgresql -y


PG_CONF="/etc/postgresql/9.1/main/postgresql.conf"
sed -i "/ssl = /s/true/off/g" $PG_CONF


service postgresql restart
