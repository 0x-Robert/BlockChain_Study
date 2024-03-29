# 마스터링 이더리움 스터디

# Ethereum

<br>

---

### 이더리움이란 무엇인가?

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 이더리움은 탈중앙화된 월드 컴퓨터다.
- 이더리움은 결정론적이고 한정되지 않은 상태 머신이며 전역적으로 접근 가능한 싱글톤 상태와 그 상태를 변화시킬 수 있는 가상머신으로 구성되어있다.
- 스마트 컨트랙트 프로그램을 실행하는 오픈소스로 된 탈중앙화된 컴퓨팅 인프라스트럭처다.

---

</details>

<br>

---

### 비트코인과의 비교

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 공통점 :

- peer-to-peer 네트워크
- 상태변경을 동기화하는 비잔틴 결함 허용 합의 알고리즘
- 디지털 서명과 해시
- 디지털 화폐

- 차이점 :

- 이더는 이더리움 플랫폼 사용료를 지불하기 위한 유틸리티 화폐다.
- 매우 제한된 스크립트 언어를 사용하는 비트코인과 달리, 임의성과 무한 복잡성을 가진 코드를 실행할 수 있는 가상머신을 운영하는 범용 프로그래밍이 가능한 블록체인
- 비트코인의 스크립트 언어가 의도적으로 지불 조건에 대한 단순한 참/거짓 평가에만 제한되어 있는 반면 이더리움은 튜링 완전(Turing complete)언어다.

</details>

---

<br>

### 블록체인의 구성요소

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 표준화된 가십(gossip) 프로토콜을 기반으로 참여자를 연결하고 트랜잭션 및 검증된 트랜잭션 블록을 연결하는 피어투피어 네트워크

- 상태전이를 나타내는 트랜잭션 형태의 메시지

- 트랜잭션의 구성 요건과 트랜잭션의 유효성을 판단하는 합의 규칙의 집합

- 합의 규칙에 따라 트랜잭션을 처리하는 상태머신

- 검증되고 적용된 모든 상태 전이의 장부역할을 해줄 수 있는 암호학적으로 보호된 체인

- 블록체인의 통제권한을 탈중앙화하는 합의 알고리즘

- 공개된 환경에서 상태머신에 경제적인 보안성을 제공할 수 있는 게임이론적으로 유효한 인센티브 메커니즘

- 위의 언급한것들을 하나로 구현한 오픈소스 소프트웨어

---

</details>

---

<br>

### 블록체인의 성격

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 공공성

- 개방성

- 국제화

- 탈중앙화

- 중립성

- 검열 저항성

---

</details>

---

<br>

### 이더리움 개발의 4단계

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 프론티어
- 홈스테드
- 메트로폴리스
- 세레니티

---

</details>

---

<br>

### 이더리움 : 범용블록체인이라고 불리는 이유는?

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 이더리움은 탈중앙화 상태 머신
- 이더리움은 키-밸류 튜플로 표현할 수 있는 모든 데이터를 저장할 수 있는 저장소의 상태 전이를 추적한다.
- 이더리움은 임의의 상태를 추적하고 상태 머신을 프로그래밍하여 합의로 작동하는 월드 와이드 컴퓨터를 뜻한다.

---

</details>

---

<br>

### 이더리움의 구성요소

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

#### 피어투피어 네트워크(P2P network)

이더리움은 TCP 포트 30303으로 접속가능한 이더리움 메인네트워크에서 실행되며 DEVp2p라는 프로토콜을 실행한다.

- https://geth.ethereum.org/docs/tools/devp2p
- https://github.com/ethereum/devp2p/blob/master/README.md

#### 합의규칙(consensus rules)

이더리움의 합의 규칙은 황서(Yellow paper)에 정의

#### 트랜잭션(transactions)

이더리움 트랜잭션은 보낸 사람, 받는 사람, 값 및 데이터 페이로드가 포함된
네트워크 메시지

#### 상태머신(state machine)

이더리움 상태 전이는 바이트코드(bytecode)를 실행하는 스택 기반 가상머신인 EVM(Ethereum Virtual Machine, 이더리움 가상머신)에 의해 처리된다. 스마트 컨트랙트라는 EVM 프로그램은 고수준 프로그래밍 언어(예: 솔리디티)로 작성되고 EVM에서 실행되도록 바이트코드로 컴파일된다.

#### 데이터 구조(data structure)

이더리움의 상태는 트랜잭션 및 시스템 상태가 머클 패트리샤 트리(Merkle Patricia Tree)라고 하는 시리얼라이즈된 해시데이터 구조로 각 노드의 데이터베이스(database, 일반적으로 구글의 levelDB)에 저장된다.

#### 합의 알고리즘(consensus algorithm)

이더리움은 비트코인의 합의 모델인 나카모토 합의(Nakamoto Consensus)를 사용한다.
나카모토 합의는 순차 단일 서명 블록을 사용하여 작업증명(PoW)의 중요도 가중치가 가장 긴 체인을 결정한다. 그러나 조만간 지분증명(PoS) 가중 투표시스템인 캐스퍼로 전환할 계획

#### 경제적 보안성(economic security)

이더리움은 지분증명 알고리즘을 사용한다.

#### 클라이언트(clients)

초기에는 geth와 parity 등만 있었지만 현재는 PoS로 전환한 이후 geth, prysm, nethermind, besu, erigon 등 여러 클라이언트가 있고 노드의 종류도 합의노드와 실행노드로 나뉜다.

---

</details>

---

<br>

### EDCSA란 ?

<details>
   <summary> 예비 답안 보기 (👈 Click)</summary>
<br />

- 타원 곡선 디지털 서명 알고리즘(Elliptic Curve Digital Signature Algorithm)의 줄임말이며 타원 곡선의 개인키-공개키 쌍을 기반으로 한다.

---

</details>

---

<br>
