#!/bin/bash


#create the subject for the certificate authority.
export CLIENT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=Travis"

rm -rf ~/client	
mkdir ~/client

date | md5sum | awk '{ print $1 }' > ~/client/phrase.txt

export CLIENT_PASSPHRASE=`cat ~/client/phrase.txt`

openssl genrsa -des3 -out client/travis.key -passout file:client/phrase.txt 4096

openssl req -new -key client/travis.key -out client/travis.csr -passin file:client/phrase.txt -subj "$CLIENT_SUBJECT"

# self-signed
openssl x509 -req -days 365 -in client/travis.csr -CA server/ca.crt -CAkey server/ca.key -set_serial 01 -out client/travis.crt 


openssl pkcs12 -export -clcerts -in client/travis.crt -inkey client/travis.key -out client/travis.p12 -passin file:client/phrase.txt

openssl pkcs12 -in client/travis.p12 -out client/travis.pem -clcerts


tar -cvzf client/travis.tar.gz client/*
