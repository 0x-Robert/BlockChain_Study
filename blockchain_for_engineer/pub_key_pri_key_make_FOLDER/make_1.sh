#openssl로 비밀키 생성하기
openssl ecparam -genkey -name secp256k1 -out secp256k1-private.pem

#BEGIN EC PRIVATE KEY와 END EC PRIVATE KEY 사이에 출력된 내용이 Base64로 인코딩된 비밀키이다. 
