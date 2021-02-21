openssl genrsa -out root.key 4096
openssl req -new \
    -key root.key \
    -subj "/C=NL/O=Koeroo/OU=Authority/CN=Root CA G1" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -addext basicConstraints=critical,CA:TRUE,pathlen:1 \
    -addext keyUsage=critical,keyCertSign,cRLSign \
    -addext certificatePolicies=1.3.3.7 \
    -addext subjectKeyIdentifier=hash \
    -addext nsComment="Koeroo Root CA - G1" \
    -out root.csr  || exit 1

openssl req -noout -text -in root.csr

openssl x509 \
    -signkey root.key \
    -days 900 \
    -req \
    -in  root.csr \
    -out root.pem

openssl x509 -noout -text -in root.pem
