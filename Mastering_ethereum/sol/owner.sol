//생성자와 컨트랙트의 이름이 정확히 동일하지 않아서 보안취약점 문제가 발생한다.

contract OwnerWallet{

    address public owner;

    //생성자
    function ownerWallet(address _owner) public {
        owner = _owner;
    }

    //폴백, 이더를 모은다.
    function () payable {}

    function withdraw() public {
        require(msg.sender == owner);
        msg.sender.transfer(this.balance);
    }
}
