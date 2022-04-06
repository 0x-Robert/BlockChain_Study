openssl ec -in secp256k1-private.pem -pubout -outform DER | tail -c 65 | xxd -p -c 65 
