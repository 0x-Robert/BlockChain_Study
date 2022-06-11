// include listing 3.1 data here

    
   // modifiers
   modifier validPhase(Phase reqPhase) 
    { require(state == reqPhase); 
      _; 
    } 
    
     
    constructor (uint numProposals) public  {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight 2 for testing purposes
        //proposals.length = numProposals; -- before 0.6.0
        for (uint prop = 0; prop < numProposals; prop ++)
            proposals.push(Proposal(0));
        state = Phase.Regs; // change Phase to Regs
    
    }
       
    function changeState(Phase x) public { 
        if (msg.sender != chairperson) {revert();} 
        if (x < state ) revert();
        state = x;
    }
    
    
    function register(address voter) public validPhase(Phase.Regs) {
        if (msg.sender != chairperson || voters[voter].voted) revert(); 
        voters[voter].weight = 1;
        voters[voter].voted = false;
          
    }

   
    function vote(uint toProposal) public validPhase(Phase.Vote)  {
       
        Voter memory sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) revert(); 
        sender.voted = true;
        sender.vote = toProposal;   
        proposals[toProposal].voteCount += sender.weight;
            
        
    }

    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) { 
       
        uint winningVoteCount = 0;
        for (uint prop = 0; prop < proposals.length; prop++) 
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
       
    } 
