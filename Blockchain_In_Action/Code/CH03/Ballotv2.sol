pragma solidity >=0.4.22 <=0.6.0;
contract BallotV2 {

    struct Voter {                     
        uint weight;
        bool voted;
        uint vote;
    }
    struct Proposal {                  
        uint voteCount;
    }

    address chairperson;
    mapping(address => Voter) voters;  
    Proposal[] proposals;

    enum Phase {Init,Regs, Vote, Done}  
    Phase public state = Phase.Init;
    
    
    constructor (uint numProposals) public  {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight 2 for testing purposes
        //proposals.length = numProposals; -- before 0.6.0
        for (uint prop = 0; prop < numProposals; prop ++)
            proposals.push(Proposal(0));
        
    }
    
    function changeState(Phase x) public {
        if (msg.sender != chairperson) {revert();}
        if (x < state ) revert();
        state = x;
    }
    
    
}
