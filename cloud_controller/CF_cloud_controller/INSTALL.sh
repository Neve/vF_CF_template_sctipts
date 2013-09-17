#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

apt-get  libxml2 libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev unzip zip -y

log_dir='/var/log/cloudfoundry/'
log_file="$log_dir/cloud_controller.log"
rails_log_file="$log_dir/cloud_controller-rails.log"
pid_file="/var/run/cloudfoundry/cloud_controller.pid"
external_uri="api.vcap.me"
data_dir='/var/vcap/data/cloud_controller'
config_dir='/etc/cloudfoundry/cloud_controller'


mkdir $data_dir
mkdir $config_dir

cf_dirs=( droplets resources staging_manifests tmp )


for i in $cf_dirs ; do
  if ![ -d "$data_dir/$i" ]; then
    mkdir "$data_dir/$i"
  fi
done

vcap_install_path="/srv/cloud_controller/cloud_controller"
config_file  = "$config_dir/cloud_controller.yml"

git clone git@github.com:cloudfoundry/cloud_controller.git /srv/vcap-source/cloud_controller
cd /srv/vcap-source/cloud_controller

##############################################################
apt-get install make g++ -y
gem install nats -v 0.4.28 --no-ri --no-rdoc

USER="cloudfoundry"
GROUP="cloudfoundry"

echo "  Create user"
groupadd --gid 1002 $GROUP
useradd --home-dir /home/$USER --group $GROUP --gid 1002 --uid 1002 $USER

echo "  Create dirs and logfile"
mkdir /etc/cloudfoundry/
mkdir /var/run/cloudfoundry/
mkdir /var/log/cloudfoundry/

touch /var/log/cloudfoundry/nats-server.log
chown cloudfoundry /var/log/cloudfoundry/nats-server.log

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
# nats-server Service

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

ln -s /lib/init/upstart-job /etc/init/nats-server
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