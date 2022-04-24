contract FunWithNumbers {


//솔리디티에는 고정소수점 유형이 없기 때문에 , 개발자는 표준 정수 데이터 타입을 사용하여 자체적으로 구현해야한다. 이과정에서 취약점이 많다.
// 12행에서 토큰값을 구할 때 값이 1보작 작은 경우 초기 나누기는 결과가 0이되고, 최종곱하기의 결과는 0이된다. 
    uint constant public tokensPerEth = 10;
    uint constant public weiPerEth = 1e18;
    mapping(address => uint) public balances;

    function buyTokens() public payable{
        //웨이를 이더로 변환한 다음, 토큰 비율로 곱한다.
        uint tokens = msg.value/weiPerEth*tokensPerEth;
        balances[msg.sender] += tokens;
    }

    function sellTokens(uint tokens) public {
        require(balances[msg.sender] >= tokens);
        uint eth = tokens/tokensPerEth;
        balances[msg.sender] -= tokens;
        msg.sender.transfer(eth*weiPerEth);
    }
}