contract EtherSTore {


    //뮤텍스 초기화
    bool reEntrancyMutex = false;
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!reEntrancyMutex);
        require(balances[msg.sender] >= _weiToWithdraw);
        //출금 금액 제한
        require(_weiToWithdraw <= withdrawalLimit);
        //출금 시간 제한
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // 외부 호출 전에 reEntrancy 뮤텍스 설정
        reEntracyMutex = true;
        msg.sender.transfer(_weiToWithdraw);
        //외부호출 후에 뮤텍스 해제
        reEntracyMutex = false;
        
    }
}