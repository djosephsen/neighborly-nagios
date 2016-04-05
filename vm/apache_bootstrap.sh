#!/usr/bin/env bash

HOME=/tmp/installs

#deps
apt-get update
apt-get install -y make
apt-get install -y screen
apt-get install -y libgd2-xpm-dev
apt-get install -y php5-fpm
apt-get install -y spawn-fcgi fcgiwrap
apt-get install -y unzip
apt-get install -y apache2
apt-get install -y php5
apt-get install -y libapache2-mod-php5
apt-get install -y php5-gd
apt-get install -y php5-imagick
php5enmod imagick

#lolpython
apt-get install -y python-dev
apt-get install -y python-setuptools
easy_install pip

#lolrubby
#apt-get install -y ruby1.9.3
#update-alternatives --set ruby /usr/bin/ruby1.9.1
#update-alternatives --set gem /usr/bin/gem1.9.1
