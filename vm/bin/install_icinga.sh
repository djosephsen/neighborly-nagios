add-apt-repository ppa:formorer/icinga
apt-get update
apt-get install icinga2

wget 'https://www.monitoring-plugins.org/download/monitoring-plugins-2.1.2.tar.gz'

apt-get install mysql-server mysql-client

apt-get install icinga2-ido-mysql

mysql -u root -p

CREATE DATABASE icinga;
GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';

mysql -u root -p icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql

icinga2 feature enable ido-mysql

service icinga2 start

apt-get install apache2
apt-get install php5
apt-get install libapache2-mod-php5
apt-get install php5-gd
apt-get install php5-imagick
php5enmod imagick

icinga2 feature enable command

apt-get install icingaweb2

icingacli setup config webserver apache --document-root /usr/share/icingaweb2/public > /etc/apache2/sites-enabled/001-icinga.conf

addgroup --system icingaweb2
usermod -a -G icingaweb2 www-data
service apache2 restart

icingacli setup config directory

icingacli setup token create

http://localhost/icingaweb2/setup

vi /etc/php5/apache2/php.ini  # set the timezone

