//프로그램이 사용한 솔리디티 컴파일러 버전
pragma solidity ^0.4.22; 


contract owned {

    address owner;
    // 컨트랙트 생성자: owner 설정
    constructor() {
        owner = msg.sender;
    }
    //변경자 접근 제어
    modifier onlyOwner {
        require(msg.sender == owner,
            "Only the contract owner can call this function");
            _;
    }

}

contract mortal is owned {
    //컨트랙트 소멸자
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}



contract Faucet is mortal {
    event Withdrawal(address indexed to, uuint amount);
    event Deposit(address indexed from, uint amount);

    // 요청하는 사람에게 이더 주기
    function withdraw(uint withdraw_amount) public {
        //출금 금액 제한
        require(withdraw_amount <= 0.1 ether);
        require(this.balance >= withdraw_amount,
            "Insufficient balance in faucet for withdrawal request");
        //요청한 주소로 금액 보내기
        msg.sender.transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }
    //입금 금액 수락
    function () public payable {
        emit Deposit(msg.sender, msg.value);
    }
}