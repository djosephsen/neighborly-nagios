#!/bin/sh

#grab nagios and the plugins tarball 

wget 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz'
wget 'http://www.nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz'

#user management
adduser --system --no-create-home --disabled-login --group nagios
groupadd nagcmd
usermod -G nagcmd,www-data nagios
gpasswd -a www-data nagcmd

#unpack the nagios tarball
tar -zxvf nagios-4.1.1.tar.gz
cd nagios-4.1.1

#build and install nagios
./configure --prefix=/usr/local/nagios-4.1.1 --with-command-group=nagcmd 
make all install
make install-init
make install-config
make install-commandmode
ln -s /usr/local/nagios-4.1.1 /usr/local/nagios
ln -s /usr/local/nagios/etc /etc/nagios
mkdir /var/log/nagios
chown nagios:nagios /var/log/nagios

#unpack the plugins
cd ..
tar -zxvf nagios-plugins-2.1.1.tar.gz
cd nagios-plugins-2.1.1

#build and install the plugins
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make install

#make some edits 
echo '

***************************************
please make the following edits: 

vi /etc/nagios/nagios.cfg
:%s/log_file=.*/log_file=\/var\/log\/nagios\/nagios.log/

vi /etc/nagios/objects/contacts.cfg
:%s/nagiosadmin/katops/g

vi /etc/nagios/cgi.cfg
:%s/nagiosadmin/katops/g

then run install_2.sh'
