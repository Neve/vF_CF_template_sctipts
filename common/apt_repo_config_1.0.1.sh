#!/bin/bash

# Temp DNS fix

cat <<EOF > /etc/resolvconf/resolv.conf.d/head
domain eng.vmware.com
search vmaltoros.corp
nameserver 192.168.0.202
nameserver 172.25.0.10
EOF

resolvconf -u


echo "Updating apt RepoPaths"

mv /etc/apt/sources.list /etc/apt/sources.list.orig

cat <<EOF > /etc/apt/sources.list
# Byfly sources for Precise

deb http://ftp.byfly.by/ubuntu/ precise main multiverse restricted universe
deb-src http://ftp.byfly.by/ubuntu/ precise main multiverse restricted universe

deb http://ftp.byfly.by/ubuntu/ precise-updates main multiverse restricted universe
deb-src http://ftp.byfly.by/ubuntu/ precise-updates main multiverse restricted universe

# Original sources
#deb http://us.archive.ubuntu.com/ubuntu/ precise multiverse
#deb-src http://us.archive.ubuntu.com/ubuntu/ precise multiverse
#deb http://us.archive.ubuntu.com/ubuntu/ precise-updates multiverse
#deb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates multiverse


#deb http://us.archive.ubuntu.com/ubuntu/ precise universe
#deb-src http://us.archive.ubuntu.com/ubuntu/ precise universe
#deb http://us.archive.ubuntu.com/ubuntu/ precise-updates universe
#deb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates universe
EOF

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

echo "Perform apt-get update"
apt-get update
echo "Perform apt-get upgrade -y"
apt-get upgrade -y
echo "Perform apt-get dist-upgrade -y"
apt-get dist-upgrade -y



