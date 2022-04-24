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