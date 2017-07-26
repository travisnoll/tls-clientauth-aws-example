#!/bin/bash

#get the public hostname from the ec2 instance meta-data
export PUBLIC_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname` 

#create the subject for the certificate authority.
export CERT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=$PUBLIC_HOSTNAME"

rm -rf ~/server
mkdir ~/server

date | md5sum | awk '{ print $1 }' > ~/server/phrase.txt

export CA_PASSPHRASE=`cat ~/server/phrase.txt`

# generate an RSA private key 
# www.openssl.org/docs/manmaster/man1/genrsa.html
#openssl genrsa -des3 -out ~/server/ca.key -passout pass:$CA_PASSPHRASE 4096
openssl genrsa -des3 -out ~/server/ca.key -passout file:server/phrase.txt 4096

echo $CERT_SUBJECT

# PKCS#10 certificate request and certificate generating utility 
# www.openssl.org/docs/manmaster/man1/req.html
openssl req -new -x509 -days 365 -key ~/server/ca.key -out ~/server/ca.crt -passin file:server/phrase.txt -subj "$CERT_SUBJECT"

# publish new certificate and key to ssl.
sudo cp ~/server/ca.key /etc/ssl/private/
sudo cp ~/server/ca.crt /etc/ssl/certs/

