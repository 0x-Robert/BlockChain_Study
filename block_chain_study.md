# 블록체인_클레이튼 스터디











## 해시 함수 (Hash Function)







* 임의의 길이의 데이터를 고정된 길이의 데이터로 매핑하는 함수

* {해시, 해시 값, 해시 코드}= 해시 함수에 의해 얻어지는 값

* 데이터를 X 해시함수를 H라고 표기할 때 해시를 H(X)로 표기







#### Rules 

1. 하나의 데이터에서 오직 단 하나의 해시가 도출

2. 임의의 데이터 X와 Y가 있을 때 

a. if X==Y then H(X) == H(Y)

b. if H(X) == H(Y) then X == Y

c. if H(X) == H(Y) then X == Y 









## 해시함수 (Hash Function) 예제 1



같은 함수로 다른 데이터를 해시했을 경우 

* 문자열 "hello!"를 SHA-256으로 해시한 결과는 다음과 같다. 

​        CEasdfas1234dsafyas78dy6127384dsaf

* 문자열 "hello?"를 SHA-256으로 해시한 결과는 다음과 같다. 

  B45CF64asdfy98hj189jsadf89asudfahsfda



같은 함수라도 다른  데이터를 해시할 경우 결과값이 크게 다른 것을 확인할 수 있다. 

* 두 해시 함수 모두 256 비트 길이의 해시를 생성한다.

 





![block_header](block_header.png)

























