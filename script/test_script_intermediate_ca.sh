openssl genrsa -out intermediate.key 4096
openssl req -new \
    -key intermediate.key \
    -subj "/C=NL/O=Koeroo/OU=Authority/CN=Intermediate CA G1" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -addext basicConstraints=critical,CA:TRUE,pathlen:0 \
    -addext keyUsage=critical,digitalSignature,keyCertSign,cRLSign \
    -addext certificatePolicies=1.3.3.7 \
    -addext subjectKeyIdentifier=hash \
    -addext nsComment="Koeroo Intermediate CA - G1" \
    -out intermediate.csr  || exit 1

openssl req -noout -text -in intermediate.csr


cat > tmpfile <<End-of-message
[v3_intermediate]
basicConstraints = CA:TRUE,pathlen:0
keyUsage = critical,digitalSignature,keyCertSign,cRLSign
certificatePolicies = 1.3.3.7
subjectKeyIdentifier=hash
nsComment = Koeroo Intermediate CA - G1

#authorityKeyIdentifier = keyid,issuer
End-of-message


openssl x509 -req \
    -in  intermediate.csr \
    -CA root.pem \
    -CAkey root.key \
    -CAcreateserial \
    -days 899 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions v3_intermediate \
    -extfile tmpfile \
    -out intermediate.pem || exit 1


openssl x509 -noout -text -in intermediate.pem
