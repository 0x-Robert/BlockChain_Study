pragma solidity >=0.4.22 <0.6.0;
contract Ballot {

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

    enum Phase {Init, Regs, Vote, Done}
    Phase public state = Phase.Done;

    //modifiers
   modifier validPhase(Phase reqPhase)
    { require(state == reqPhase, "Not the required phase");
      _;
    }
    modifier onlyChair()
     {require(msg.sender == chairperson, "Only chairperson can perform this operation");
      _;
     }

    constructor (uint numProposals) public  {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight 2 for testing purposes
        proposals.length = numProposals;
        state = Phase.Regs;
    }

     function changeState(Phase x) onlyChair public {
        require (x > state, "Can only move to greater state");
        state = x;
     }

    function register(address voter) public validPhase(Phase.Regs) onlyChair {
        require (! voters[voter].voted);
        voters[voter].weight = 1;
       // voters[voter].voted = false;
    }


    function vote(uint toProposal) public validPhase(Phase.Vote)  {
        //Cant not use like this: Voter memory sender = voters[msg.sender];
        //Changes happen only locally
        require (!voters[msg.sender].voted, "Voter has already voted");
        require (toProposal < proposals.length, "Proposal number over limit");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = toProposal;
        proposals[toProposal].voteCount += voters[msg.sender].weight;
    }

    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) {
        uint winningVoteCount = 0;
        for (uint prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
       assert (winningVoteCount>=3);
    }
}
