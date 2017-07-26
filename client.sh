#!/bin/bash

# download certificate authority from server
openssl s_client -connect $1:443 > ca.cert

# request HEAD over ssl.
curl --head https://$1
