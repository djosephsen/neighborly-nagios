#!/bin/sh

#test the configuration
/usr/local/nagios/bin/nagios -v /etc/nagios/nagios.cfg
/etc/init.d/nagios start

#make sure the cgi services are running
service fcgiwrap status
service php5-fpm status

rm /etc/nginx/sites-enabled/default
cp /vagrant/conf/nagios.busycorp.com.conf /etc/nginx/sites-available/nagios.busycorp.com.conf
ln -s /etc/nginx/sites-available/nagios.busycorp.com.conf /etc/nginx/sites-enabled

echo '
*********************
lets set a password for the Nagios Web UI

'
P=$(openssl passwd -crypt)
echo "katops:${P}" >> /etc/nagios/htpasswd.users
service nginx reload
