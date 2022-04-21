contract EtherGame {

    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether ;
    uint public finalReward = 5 ether; 
    uint public depositedWei;

    mapping (address => uint ) redeemableEther;

    function play() public payable {
        require(msg.value == 0.5 ether);
        uint currentBalance = depositedWei + msg.value;
        // 게임이 끝난 후에 어떤 선수도 없도록 확인하기
        require(currentBalance <= finalMileStone);
        if(currentBalance == payoutMileStone1){
            redeemableEther[msg.sender] += mileStone1Reward;

        }
        else if (currentBalance == finalMileStone){
            redeemableEther[msg.sender] += finalReward;

        }
        depositedWei += msg.value;
        return;

    }

    function claimReward() public {
        // 게임이 완료되었는지 확인하기
        require(depositedWei == finalMileStone);
        //보상이 주어지도록 확인하기
        require(redeemableEther[msg.sender] > 0);
        redeemableEther[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
}
