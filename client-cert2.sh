#!/bin/bash


#create the subject for the certificate request.
export CLIENT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=Travis"

rm -rf ~/client	
mkdir ~/client

#date | md5sum | awk '{ print $1 }' > ~/client/phrase.txt

#export CLIENT_PASSPHRASE=`cat ~/client/phrase.txt`

openssl genrsa  -out client/travis.key 4096

openssl req -new -key client/travis.key -out client/travis.csr -subj "$CLIENT_SUBJECT"

openssl x509 -req -days 365 -in client/travis.csr -CA /etc/ssl/certs/ca.crt -CAkey ./server/ca.key -set_serial 01 -out client/travis.crt



tar -cvzf client/travis.tar.gz client/*
