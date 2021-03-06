#!/usr/bin/env bash

HOME=/tmp/installs

#deps
apt-get update
apt-get install -y make
apt-get install -y screen

#lolpython
apt-get install -y python-dev
apt-get install -y python-setuptools
easy_install pip

apt-get install -y nagios-plugins
mkdir -p /usr/local/nagios/
ln -s /usr/lib/nagios/plugins /usr/local/nagios/libexec

wget https://assets.nagios.com/downloads/ncpa/ncpa-1.8.1-1.amd64.deb
dpkg -i ncpa-1.8.1-1.amd64.deb
