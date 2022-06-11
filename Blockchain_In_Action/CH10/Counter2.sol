pragma solidity ^0.6.0;

contract Counter2 {
    int value; //양숫값 카운터
    constructor() public {
        value = 0;

    }

    modifier checkIfLessThanValue(int n){
        require (n <= value, 'Counter cannot become negative');
        _;
    }
    modifier checkIfNegative(int n){
        require(n > 0, 'Value must be greater than zero');
        _;
    }

    function get() view public returns (int){
        return value;
    }

    function initialize (int n ) checkIfNegative(n) public {
        value = n;
    } 

    function increment (int n) public checkIfNegative(n){
        value = value + n;
    }

    function decrement (int n ) public checkIfNegative(n){
        checkIfLessThanValue(n){
            value = value - n;
        }

    }

    

}