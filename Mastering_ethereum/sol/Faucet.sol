// Faucet.sol : Faucet을 구현하는 솔리디티 컨트랙트
// 실행법 solc --optimize --bin Faucet.sol
// 우리의 첫번째 컨트랙트는 Faucet이다.
// 솔리디티 버전 0.4.24

contract Faucet {

    //요청하는 사람에게 이더 주기
    function withdraw(uint withdraw_amount) public {
        //출금 액수 제한
        require(withdraw_amount <= 100000000000000000);

        //요청한 주소로 금액 보내기
        msg.sender.transfer(withdraw_amount);
        
    }

    // 입금 금액 수락
    // function () public payable {} 에러발생 / 원인 : 솔리디티 버전이 올라가면서 payable 함수는 function이 아니라 fallback 으로 수행해야한다.
    fallback () public payable {}
    



}
