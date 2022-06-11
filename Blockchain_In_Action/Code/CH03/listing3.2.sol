enum Phase {Init, Regs, Vote, Done}    
    // Phase can take only 0,1,2,3 values: Others invalid
   
 Phase public state = Phase.Init;
    
    constructor (uint numProposals) public  { 
        chairperson = msg.sender;              
        voters[chairperson].weight = 2; // weight 2 for testing purposes
        //proposals.length = numProposals; -- before 0.6.0
        for (uint prop = 0; prop < numProposals; prop ++)
            proposals.push(Proposal(0));    
   
    }
    
    
       // function for changing Phase: can be done only by chairperson
    function changeState(Phase x) public {     
       if (msg.sender != chairperson) {revert();}  
       if (x < state) revert();   
       state = x;
    }
    
    }
