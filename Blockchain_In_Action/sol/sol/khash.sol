pragma solidity >=0.4.22 <=0.6.0;

//keccak 해시 함수를 위한 간단한 솔리디티 코드

contract Khash{
    bytes32 public hashedValue;
    function hashMe(uint value1, bytes32 password) public {
        hashedValue = keccak256(abi.encodePacked(value1, password));

    }
}