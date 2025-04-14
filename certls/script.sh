# Generate Root Key rootCA.key with 2048
openssl genrsa -passout pass:"$1" -des3 -out rootCA.key 2048

# Generate Root PEM (rootCA.pem) with 1024 days validity.
openssl req -passin pass:"$1" -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=Local Certificate" \
  -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem

# Add root cert as trusted cert (For Debian/Ubuntu systems)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Debian/Ubuntu
    apt-get update
    apt-get install -y ca-certificates
    cp rootCA.pem /usr/local/share/ca-certificates/
    update-ca-certificates
    # meeting ES requirement
    sysctl -w vm.max_map_count=262144
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem
else
    echo "Unsupported Operating System. Exiting Now ......"
    exit 1
fi

# Generate ES01 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost" \
  -new -sha256 -nodes -out es01.csr -newkey rsa:2048 -keyout es01.key
openssl x509 -req -passin pass:"$1" -in es01.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial \
  -out es01.crt -days 500 -sha256 \
  -extfile <(printf "subjectAltName=DNS:localhost,DNS:es01,IP:127.0.0.1,IP:192.168.4.28")

# Generate Kib01 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost" \
  -new -sha256 -nodes -out kib01.csr -newkey rsa:2048 -keyout kib01.key
openssl x509 -req -passin pass:"$1" -in kib01.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial \
  -out kib01.crt -days 500 -sha256 \
  -extfile <(printf "subjectAltName=DNS:localhost,DNS:kib01,IP:127.0.0.1,IP:192.168.4.28")
