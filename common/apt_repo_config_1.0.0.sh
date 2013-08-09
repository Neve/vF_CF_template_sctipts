#!/bin/bash

# 10.04 ssh fix
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''



mv /etc/apt/sources.list /etc/apt/sources.list.orig

cat <<EOF > /etc/apt/sources.list
# Byfly sources for lucid
deb http://ftp.byfly.by/ubuntu/ lucid main
deb-src http://ftp.byfly.by/ubuntu/ lucid main

deb http://ftp.byfly.by/ubuntu/ lucid universe
deb-src http://ftp.byfly.by/ubuntu/ lucid universe

deb http://ftp.byfly.by/ubuntu/ lucid-updates universe
deb-src http://ftp.byfly.by/ubuntu/ lucid-updates universe


deb http://ftp.byfly.by/ubuntu/ lucid multiverse
deb-src http://ftp.byfly.by/ubuntu/ lucid multiverse

deb http://ftp.byfly.by/ubuntu/ lucid-updates multiverse
deb-src http://ftp.byfly.by/ubuntu/ lucid-updates multiverse

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

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/vmware/bin

apt-get update
apt-get -f install -y
apt-get upgrade -y

########
#Orig
########
#!/bin/bash
#set -e

# Import global conf
#. $global_conf

#cp /etc/apt/sources.list /etc/apt/sources.list.orig

#if [ x$remove_all_repos = 'xtrue' ]; then
#    sed -i -e "s/^deb/# deb/g" /etc/apt/sources.list
#fi

# Strip all chars that are not part of the whitelist
#fixed_repository_name=$(echo $repository_name | sed 's/[^-._a-zA-Z0-9]//')

#if [ "x$fixed_repository_name" = "x" ]; then
#    echo "Illegal characters were stripped from the provided repository_name but now it's empty. Please fix the repository_name property before re-running. Allowed character include: a-z A-Z 0-9 . _ -"
#    exit 1
#fi

#echo "deb $source_str" >> "/etc/apt/sources.list.d/$fixed_repository_name.sources.list"

#apt-get update


