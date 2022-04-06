#비밀키를 16진수로 출력하기
openssl ec -in secp256k1-private.pem -outform DER | tail -c +8 | head -c 32 | xxd -p -c 32 
