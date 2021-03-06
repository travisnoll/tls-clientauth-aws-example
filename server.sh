export PUBLIC_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname` 
export CERT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=$PUBLIC_HOSTNAME"

date | md5sum | awk '{ print $1 }' > phrase.txt

#openssl req -x509 -newkey rsa:4096 -passout file:phrase.txt -subj "$CERT_SUBJECT" -out tlsca-CA.pem -keyout tlsca-KEY.pem 
openssl req -x509 -newkey rsa:4096 -subj "$CERT_SUBJECT" -out tlsca-CA.pem -keyout tlsca-KEY.pem -nodes


sudo cp tlsca-CA.pem /etc/ssl/certs/tlsca-ca.crt
sudo cp tlsca-KEY.pem /etc/ssl/private/tlsca-ca.key



export CLIENT_SUBJECT="/C=US/ST=Minnesota/L=Minneapolis/O=University of Minnesota/OU=ahcis/CN=Travis"
openssl req -newkey rsa:4096 -subj "$CLIENT_SUBJECT" -out client-CA.csr -keyout client-KEY.pem -nodes
openssl x509 -req -days 730 -in client-CA.csr -CA tlsca-CA.pem -CAkey tlsca-KEY.pem -set_serial 01 -out client-CERT.pem



#openssl req -x509 -newkey rsa:4096 -subj "$CLIENT_SUBJECT" -out client-CA.pem -keyout client-KEY.pem -nodes
#openssl x509 -CA tlsca-CA.pem -CAkey tlsca-KEY.pem -in client-CA.pem -out client-signed.pem -set_serial 01




#openssl req -x509 -newkey rsa:4096 -passout file:phrase.txt -subj "$CLIENT_SUBJECT" -out client-CA.pem -keyout client-KEY.pem
#openssl x509 -CA tlsca-CA.pem -CAkey tlsca-KEY.pem -in client-CA.pem -out client-signed.pem -passin file:phrase.txt -set_serial 01
#openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt


#openssl genrsa -out ia.key 4096
#openssl req -new -key ia.key -out ia.csr
#penssl x509 -req -days 730 -in ia.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ia.crt

