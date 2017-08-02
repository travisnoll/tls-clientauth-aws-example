# tls-clientauth-aws-example
Demonstrate how to set up self-signed certificate with apache requiring tls client-auth.

This is a good walkthrough:
https://blog.didierstevens.com/2008/12/30/howto-make-your-own-cert-with-openssl/


Launch an ubuntu ec2 instance using this as your user data script:
```
#!/bin/sh
curl https://raw.githubusercontent.com/travisnoll/tls-clientauth-aws-example/master/ubuntu-bootstrap.sh | sh
```

This should setup apache with a self-signed certificate and a set of client credentials.

Figure out the Public DNS (IPv4) of your instance and point a web browser at it (HTTP) -- you should get the default ubuntu page.  Then point the browser at HTTPS -- you'll get a cert error because the cert we used is self signed and your browser doesn't have it.


To exercise the new server you have to find a client.  I just use another ec2 instance.

This command will pull down the Certificate Authority from your newly provisioned apache2/ssl server.
```
openssl s_client -connect ec2-WW-XX-YY-ZZ.compute-1.amazonaws.com:443 > ca.cert
```

now if you use curl thusly you'll try to connect:
```
curl --cacert ./ca.cert --head https://ec2-WW-XX-YY-ZZ.compute-1.amazonaws.com
```
This should fail with the error:
curl: (35) gnutls_handshake() failed: Handshake failed

This fails because we configured apache on our server to REQUIRE client-auth with the line:
    SSLVerifyClient require

Notice the commented out optional line.  If you change the configuration and restart apache (sudo service apache2 restart) you can connect.

SSH into the instance and you'll see that server.sh has created a couple useful files, particularly:
> client-KEY.pem
> client-CERT.pem

We need to get these files to our client host if we're going to be able to authenticate from there.  I use scp but there are lots of ways to solve that problem.

Finally, once you have the KEY and CERT for the client in place you can call:
```
curl --cacert ./ca.cert --cert-type pem --head https://ec2-WW.XX.YY.ZZ.compute-1.amazonaws.com --cert ./client-CERT.pem --key client-KEY.pem
```
To use the https against the server with the self-signed certificate in place, requiring the signed client certificate!  Now you can authenticate users of your API without OAuth and without passwords.  Signed Credentials sent to the server are verified and the contents configured in environment variables to the underlying application code.

Next steps for me:  Get rails running on passenger to inspect the credentials from within apache to authorize a specific user.
