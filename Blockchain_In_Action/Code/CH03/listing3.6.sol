if (msg.sender != chairperson ..) 


   modifier onlyChair () 
   { require(msg.sender == chairperson);
  _; 
}

function register(address voter) public validPhase(Phase.Reg) onlyChair {
