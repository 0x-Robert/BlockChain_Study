pragma solidity ^0.6.0;

contract AccountDemo {
    address public whoDeposited;
    uint public depositAmt;
    uint public accountBalance;


    function deposit() public payable {
        whoDeposited = msg.value;
        depositAmt = msg.value;
        accountBalance = address(this).balance; 
        
    }
}