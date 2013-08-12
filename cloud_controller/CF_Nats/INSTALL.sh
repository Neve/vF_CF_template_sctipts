#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

apt-get install make g++ -y
gem install nats -v 0.4.28

USER="cloudfoundry"
GROUP="cloudfoundry"

echo "  Create user"
groupadd --gid 1002 $GROUP
useradd --home-dir /home/$USER --group $GROUP --gid 1002 --uid 1002 $USER

mkdir /etc/cloudfoundry/
mkdir /var/run/cloudfoundry/
mkdir /var/log/cloudfoundry/

echo "  Create Nats config file"
cat <<EOF > /etc/cloudfoundry/nats-server.yml
---
net: 0.0.0.0
port: 4222

pid_file: /var/run/cloudfoundry/nats-server.pid
log_file: /var/log/cloudfoundry/nats-server.log

authorization:
  user: nats
  password: nats
  timeout: 20
EOF



echo "  Create service"
cat <<EOF > /etc/init/nats-server.conf
nats-server Service

description     "nats-server"
author          "nats"

start on (net-device-up
          and filesystem
      and runlevel [2345])
stop on runlevel [016]

respawn

env PATH="/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
env PIDFILE="/var/run/cloudfoundry/nats-server.pid"
export PATH
export PIDFILE

pre-start script
  mkdir -p `dirname '/var/run/cloudfoundry/nats-server.pid'`
  chown cloudfoundry:cloudfoundry `dirname '/var/run/cloudfoundry/nats-server.pid'`
end script

exec start-stop-daemon --start --chuid cloudfoundry --pid /var/run/cloudfoundry/nats-server.pid --startas /usr/bin/ruby -- /usr/local/bin/nats-server -c /etc/cloudfoundry/nats-server.yml

EOF

ln -s /etc/init/nats-server /lib/init/upstart-job
#/etc/init.d/nats-server
#chmod +x /etc/init.d/nats-server


echo "  Create Logrotate config"
cat <<EOF >  /etc/logrotate.d/nats-server
/var/log/cloudfoundry/nats-server.log {
  daily
  missingok
  rotate 30
  compress
  delaycompress
  copytruncate
  notifempty
  create 644 root root
}
EOF