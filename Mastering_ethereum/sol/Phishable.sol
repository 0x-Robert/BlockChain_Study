//솔리디티에는 글로벌 변수 tx.origin이 있다. 이는 전체 호출스택을 가로지르고 원래 호출을 보낸 계정의 주소를 포함한다.
// 스마트 컨트랙트에서 이 변수를 인증에 사용하면 컨트랙트가 phishing에 취약해진다.


contract Phishable{

    address public owner;

    constructor (address _owner){
        owner = _owner;
    }
    function () public payable {} //이더를 모은다.
    function withdrawAll(address _recipient) public{
        require(tx.origin == owner);
        _recipient.transfer(this.balance);
    }
}

