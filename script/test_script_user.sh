
COMMONNAME="Oscar Koeroo"

openssl genrsa -out user.key 4096
openssl req -new \
    -key user.key \
    -subj "/C=NL/O=Koeroo/OU=Authority/CN=${COMMONNAME}" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -addext basicConstraints=critical,CA:FALSE \
    -addext keyUsage=digitalSignature,nonRepudiation,keyEncipherment \
    -addext certificatePolicies=1.3.3.7 \
    -addext subjectKeyIdentifier=hash \
    -addext nsComment="Koeroo Host" \
    -out user.csr  || exit 1

openssl req -noout -text -in user.csr

cat > tmpfile <<End-of-message
[v3_host]
basicConstraints = CA:FALSE
keyUsage = digitalSignature,nonRepudiation,keyEncipherment
extendedKeyUsage = clientAuth, emailProtection
nsCertType = client, email
certificatePolicies = 1.3.3.7
subjectKeyIdentifier=hash
nsComment="Koeroo User"

authorityKeyIdentifier = keyid,issuer

subjectAltName = @alt_names
[alt_names]
email = okoeroo@gmail.com
End-of-message


openssl x509 -req \
    -in  user.csr \
    -CA intermediate.pem \
    -CAkey intermediate.key \
    -CAcreateserial \
    -days 300 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions v3_host \
    -extfile tmpfile \
    -out user.pem || exit 1


openssl x509 -noout -text -in user.pem

