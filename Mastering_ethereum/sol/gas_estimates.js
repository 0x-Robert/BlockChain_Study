var FaucetContract = artifacts.requires("./Faucet.sol");

FaucetContract.web3.eth.getGasPrice(function(error, result){

    var gasPrice = Number(result);
    console.log("Gas Price is " + gasPrice + " wei"); // "10000000000000"


    // 컨트랙트 인스턴스 얻기
    FaucetContract.deployed().then(function(FaucetContractInstance){
        // 이 특정한 함수를 위한 가스 예상치를 얻기 위해
        // 함수명 뒤에 'estimateGas'라는 키워드를 사용
        FaucetContractInstance.send(web3.toWei(1, "ether"));
        return FaucetContractInstance.withdraw.estimateGas(web3.toWei(0.1, "ether"));

    }).then(function(result){
        var gas = Number(result);

        console.log("gas estimation = " + gas + " units ");
        console.log("gas cost estimation = " + (gas * gasPrice) + " wei");
        console.log("gas cost estimation = " + 
                FaucetContract.web3.fromWei((gas*gasPrice), 'ether') + " ether");
    })
})