#!/bin/sh
apt-get -y update
apt-get -y upgrade
apt-get -y install apache2

sudo -H -u ubuntu bash -c 'cd; git clone https://github.com/travisnoll/tls-clientauth-aws-example.git ~ubuntu/tls-clientauth-aws-example' 

rm /etc/apache2/sites-enabled/*
cp /home/ubuntu/tls-clientauth-aws-example/tls-clientauth.conf /etc/apache2/sites-available/
ln -s /etc/apache2/sites-available/tls-clientauth.conf /etc/apache2/sites-enabled/
sudo a2enmod ssl

sudo -H -u ubuntu bash -c 'cd; bash ~ubuntu/tls-clientauth-aws-example/server3.sh' 

service apache2 restart
