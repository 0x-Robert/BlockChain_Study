pragma solidity ^0.6.2; 
// imagine a big integer counter that the whole world could share
contract Counter {
    uint value; 
    function initialize (uint x) public { 
        value = x;
        
    }

    function get() view public returns (uint) { 
        return value;
    }
    
    function increment (uint n) public { 
        value = value + n;
        // return (optional)
    }
    
    function decrement (uint n) public { 
        value = value - n;
        
    }
}
