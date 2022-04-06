#메시지로부터 만든 해시값을 hashed_message.txt 라는 또 다른 파일에 출력한다.
sha256sum message.txt | cut -c1 -64 > hashed_message.txt
cat hashed_message.txt
