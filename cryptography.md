# 암호학

- 암호학은 그리스어로 "비밀 작성"을 뜻하지만 암호학 연구는 "암호화(encryption)"라고 하는 단순 비밀작성 이상의 것을 포함한다.

* 이더리움에서 사용하는 암호방식 : 공개키 암호화(Public Key Cryptography, PKC)
* 이더리움은 외부 소유 계정 (Externally Owned Account, EOA)와 컨트랙트(contract)라는 두가지 유형의 계정을 갖고 있다.
* 디지털 개인키(private key), 이더리움 주소(ethereum address), 디지털 서명(digital signature)를 통해 외부 소유 계정(EOA)의 이더 소유권을 확립한다.
* 계정 주소는 개인키에서 파생된다. / 개인키는 계정(account)라고 불리는 단일 이더리움 주소를 고유하게 결정한다.
* 이더리움 시스템은 개인키를 이더리움에 전송하거나 저장하는 방식으로 직접 사용되지 않고 비공개로 유지되어야 한다.
* 계정 주소와 디지털 서명만 이더리움 시스템에 전송되고 저장된다.
* 개인키를 사용하여 생성된 디지털 서명을 통해 자금의 접근과 통제가 이루어진다.
* 외부소유계정(EOA)의 이더리움 주소는 공개키-개인키 쌍에서 공개키에서 생성된다.
* 공개키 암호화(비대칭 암호화라고도 함)은 오늘날 정보 보안의 핵심요소다. 1970년대 마틴핼먼(Martin Hellman), 휫필드 디피(Whitfield Diffie), 랄프 머클(Ralph Merkle)이 공개했다.
* 공개키 암호화는 고유한 키를 사용해서 정보를 보호한다. 이 키는 특수한 속성(계산은 쉽지만 그 역계산은 어려운 속성)을 가진 수학함수를 바탕으로 한다.
* 초기 공개 키 암호 방식은 아주 큰 정수를 2개 이상의 소수로 나누는 것이 오래걸리는 것에 기반을 두고 있다
* 이런 수학함수 중 일부는 다음과 같다.
* 트랩도어함수(trapdoor function) : 8,018,009가 두 소수의 곱일 때 비밀정보 중 하나가 소인수 중 하나가 2,003이라고 하면 나머지는 쉽게 찾을 수 있다. 그러나 역산하기 위한 단축키로 사용할 수 있는 비밀 정보가 없을 때는 8,018,009의 역계산이 어렵기 때문에 트랩 도어 함수라고 한다.
* 암호화에 유용한 수학함수의 발전은 타원곡선의 산술연산을 바탕으로 한다. 타원곡선산술에서 소수로 나눈 나머지를 곱하는 것은 간단하지만 나눗셈(역산)은 사실상 불가능하다.
  이것을 이산 로그 문제(discrete logarithm problem)라고 하며 현재는 알려진 트랩도어는 없다.
* 타원곡선 암호화(elliptic curve cryptography)는 이더리움 및 기타 암호화폐에서 개인키와 디지털 서명을 사용하는 기초가 된다.
* 타원곡선 암호 또한 알려진 특정한 점에 대한 무작위 타원 곡선의 이산 로그를 찾는 것이 오래걸린다는 점에서 착안하였다.
* 암호화 목적으로 타원곡선은 평면곡선의 한 종류로 다음의 방정식을 만족하는 점(무한 원점포함)들의 집합이다. (곡선의 단순함을 위해 점들은 표수가 2나 3이 아닌 고정된 유한체이다.)
  y^2 =x^3 + ax +b

# 참고

- 영 지식 증명(zero knowledge proof)
- 동형 암호화(homomorphicencryption)
- 암호학(http://bit.ly/2DcwNhn) - https://en.wikipedia.org/wiki/Cryptography
  (공개키 암호시스템, 대칭키 시스템)
- 타원곡선암호(Elliptic curve cryptography) : https://ko.wikipedia.org/wiki/%ED%83%80%EC%9B%90%EA%B3%A1%EC%84%A0_%EC%95%94%ED%98%B8
- 트랩도어함수(http://bit.ly/2zeZV3c) : https://ko.wikipedia.org/wiki/%ED%8A%B8%EB%9E%A9%EB%8F%84%EC%96%B4_%ED%95%A8%EC%88%98
- 타원곡선암호 : https://web.archive.org/web/20170428225556/http://www.secg.org/SEC1-Ver-1.0.pdf
- Certicom은 타원곡선암호와 관련된 원천기술을 가진 회사이며, 2003년에 미국 NSA와 타원곡선암호 기술에 관한 라이선스 계약을 맺었다. : https://blackberry.certicom.com/en
- SEC1. 타원곡선 암호 표준 : https://web.archive.org/web/20170428225556/http://www.secg.org/SEC1-Ver-1.0.pdf
- SEC2. 제안된 곡선들 : https://web.archive.org/web/20170630012610/http://www.secg.org/SEC2-Ver-1.0.pdf

# 출처

마스터링 이더리움
