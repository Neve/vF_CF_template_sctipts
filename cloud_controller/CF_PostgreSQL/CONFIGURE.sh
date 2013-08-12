#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

DB_NAME='cloud_controller'
DB_USER='cloudfoundry'
DB_PASS='cloudfoundry'



echo "  Create user "
sudo -u postgres psql -c "CREATE ROLE $DB_USER WITH SUPERUSER LOGIN PASSWORD '$DB_PASS';"
echo "   Create database"
sudo -u postgres createdb $DB_NAME
echo "   Grant privileges"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

