//블록 타임스탬프 조작 , 채굴자는 타임스탬프를 약간 조정할 수 있는데, 이 때문에 ,스마트 컨트랙트에서 블록타임스탬프를 잘못 사용하면 위험할 수 있다.
//


contract Roulette {

    uint public pastBlockTime; //블록당 하나의 베팅을 강요
    constructor() public payable {} //초기 펀드 컨트랙트

    // 베팅을 하기 위해 사용하는 폴백 함수
    function () public payable {
        require(msg.value == 10 ether); // 실행하기 위해 10 이더를 보내야한다. 
        require(now != pastBlockTime); //블록당 오직 1 트랜잭션
        pastBlockTime = now;
        if (now % 15 == 0){
            //승자
            msg.sender.transfer(this.balance);
        }
    }
}