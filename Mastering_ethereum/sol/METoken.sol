//ERC20토큰을 구현하는 솔리디티 컨트랙트

pragma solidity ^0.4.21; 

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol'

contract METoken is StandardToken{
    string public constant name = 'Mastering Ethereum Token';
    string public constant symbol = "MET";
    uint8 public constant decimals = 2;
    uint constant _initial_supply = 2100000000;

    function METoken() public {
        totalSupply_ = _initial_supply;
        balances[msg.sender] = _initial_supply;
        emit Transfer(Address(0), msg.sender, _initial_supply);
    }
}