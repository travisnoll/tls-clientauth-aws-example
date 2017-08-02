#!/bin/bash

# download certificate authority from server
openssl s_client -connect $1:443 > ca.cert

# request HEAD.
curl --head $1
# This works because we happily respond over http(80).

# request HEAD over ssl.
curl --head https://$1
# This fails because our certificate chain doesn't recognize the certificate authority.

# request HEAD over ssl ignoring certificate troubles.
curl --insecure --head https://$1
# This fails because we are REQUIRING client-auth on the server.

# request HEAD over ssl using self signed certificate authority.
curl --head --cacert ./ca.cert https://$1
# This also fails because we are REQUIRING client-auth on the server.

# request HEAD over ssl using self signed certificate authority.
curl --head --cacert ./ca.cert --cert ./client-CERT.pem --key ./client-KEY.pem https://$1
# Finally, this succeeds with a status of 200 OK becuase the client and server trust eachother.
