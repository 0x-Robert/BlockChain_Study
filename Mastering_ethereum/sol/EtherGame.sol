contract EtherGame {


    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether; 



    mapping(address => uint) redeemableEther;
    //사용자는  0.5 이더를 지불한다. 특정 이정표에서 그들의 계정에 입금한다.

    function play() public payable {
        require(msg.value == 0.5 ether); //각각의 지불액은 0.5이더다.
        uint currentBalance = this.balance + msg.value; 
        //게임이 끝난 후에 어떤 선수도 없도록 확인하기
        require(currentBalance <= finalMileStone);
        // 이정표에서 선수의 계쩡으로 입금하기

        if (currentBalance == payoutMileStone1){
            redeemableEther[msg.sender] += mileStone1Reward;

        }
        else if (currentBalance == payoutMileStone2) {
            redeemableEther[msg.sender] += mileStone2Reward;
        }
        else if (currentBalance == finalMileStone){
            redeemableEther[msg.sender] += finalReward;
        }
        return;
    }

    function claimReward() public {
        //게임이 완료되었는지 확인하기
        require(this.balance == finalMileStone);
        // 보상이 주어지도록 확인하기
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] > 0;
        msg.sender.transfer(transferValue);
    }
    
}
}