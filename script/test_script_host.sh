openssl genrsa -out host.key 4096
openssl req -new \
    -key host.key \
    -subj "/C=NL/O=Koeroo/OU=Authority/CN=Host 2" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -addext basicConstraints=critical,CA:FALSE \
    -addext keyUsage=digitalSignature,nonRepudiation,keyEncipherment \
    -addext certificatePolicies=1.3.3.7 \
    -addext subjectKeyIdentifier=hash \
    -addext nsComment="Koeroo Host" \
    -out host.csr  || exit 1

openssl req -noout -text -in host.csr

cat > tmpfile <<End-of-message
[v3_host]
basicConstraints = CA:FALSE
keyUsage = digitalSignature,nonRepudiation,keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
nsCertType = client, server
certificatePolicies = 1.3.3.7
subjectKeyIdentifier=hash
nsComment="Koeroo Host"

authorityKeyIdentifier = keyid,issuer

subjectAltName = @alt_names
[alt_names]
DNS.1 = host1.koeroo.foo
DNS.2 = host2.koeroo.foo

End-of-message


openssl x509 -req \
    -in  host.csr \
    -CA intermediate.pem \
    -CAkey intermediate.key \
    -CAcreateserial \
    -days 300 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions v3_host \
    -extfile tmpfile \
    -out host.pem || exit 1


openssl x509 -noout -text -in host.pem

