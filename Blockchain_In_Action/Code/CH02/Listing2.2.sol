pragma solidity ^0.6.0;
contract AccountsDemo {
    address public whoDeposited;
    uint public depositAmt;
    uint public accountBalance;
    
    function deposit() public payable
    {
        whoDeposited = msg.sender;
        depositAmt = msg.value;
        
        accountBalance = address(this).balance;
    }
    
}​