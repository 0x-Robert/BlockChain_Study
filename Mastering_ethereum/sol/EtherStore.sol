contract EtherStore {

    //입금자가 1주일에 1 이더만 회수할 수 있게 하는 이더리움 보관소 기능
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value; 
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        
        //출금 금액 제한
        require(_weiToWithdraw <= withdrawalLimit);

        //출금 시간 제한
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiToWithdraw)());
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now; 

    }



}