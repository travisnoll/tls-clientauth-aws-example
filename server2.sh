#!/bin/bash

#get the public hostname from the ec2 instance meta-data
export PUBLIC_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname` 

#create the subject for the certificate authority.
export CERT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=$PUBLIC_HOSTNAME"

rm -rf ~/server
mkdir ~/server

date | md5sum | awk '{ print $1 }' > ~/server/phrase.txt

export CA_PASSPHRASE=`cat ~/server/phrase.txt`




openssl req -new -subj "$CERT_SUBJECT" -passout file:server/phrase.txt -keyout server/key.pem > server/ca.csr

openssl rsa -in server/key.pem -out server/ca.key -passin file:server/phrase.txt

openssl x509 -in server/ca.csr -out server/ca.crt -req -signkey server/key.pem -days 365 -passin file:server/phrase.txt



# publish new certificate and key to ssl.
sudo cp ~/server/ca.key /etc/ssl/private/
sudo cp ~/server/ca.crt /etc/ssl/certs/

