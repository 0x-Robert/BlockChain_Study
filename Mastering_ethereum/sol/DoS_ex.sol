//서비스거부(DOS)
//외부에서 조작된 매핑 또는 배열을 통한 루핑

contract DistributeTokens {
    address public owner; //owner를 가져온다.
    address[] investors; //investors 배열
    uint[] investorTokens; //각 investor가 얻은 토큰의 양

    //transfertoken()을 포함하는 추가 기능
    function invest() public payable{
        investors.push(msg.sender);
        investorTokens.push(msg.sender * 5); //전송한 wei의 5배
    }

    function distribute() public {
        require(msg.sender == owner); //소유자만 
            // 여기서 transferToken(to, amount)는 토큰의 amount를 
            // 주소 to로 전송한다.
            transferToken(investors[i] , investorTokens[i]);
    }
}
}
