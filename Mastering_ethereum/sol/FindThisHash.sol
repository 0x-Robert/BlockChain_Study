/// 트랜잭션에 대한 정보를 트랜잭션 풀에서 보고, 해답자의 권한을 수정 또는 취소하거나 트랜잭션의 상태를 해답자에게 불리하게 바꿀 수 있다.
// 그런 다음 공격자는 이 트랜잭션에서 데이터를 가져와서 자신의 트랜잭션을 생성하되, 원본보다 먼저 블록체인에 포함되도록 하기위해 더 높은 가스 값을 설정할 수 있다.
//공격자가 채굴자가 되는 이런 프런트 러닝 취약점을 주의해야한다.

contract FindThisHash {
    bytes32 constant public hash = 
        0xa0dnfiasnfiaosenroiawmoamfs9das238nds0afn09134na;

        constructor() public payable { } //이더입금
        function solve(string solution) public {
            //해시의 사전 이미지를 찾을 수 있다면 1000이더를 받는다.
            require(hash == sha3(solution));
            msg.sender.transfer(1000 ether);
        }
}
