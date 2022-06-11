//수정자

modifier validPhase(Phase reqPhase){
    require(state == reqPhase);
    _;
}


modifier onlyChair(){
    require(msg.sender == chairperson);
    _;
}

constructor (uint numProposals) public. {
    chairperson = msg.sender;
    voters[chairperson].weight = 2; // 테스트 목적으로 가중치를 2로 설정
    for (uint prop = 0; prop < numProposals; prop++){
        proposals.push(Proposal(0));
        state = Phase.Regs;
    }
    
}

function changeState(Phase x) onlyChair public {
    //onlyChair 수정자 사용
    require (x > state);
    state = x;
}

function register(address voter ) public validPhase(Phase.Regs){
    onlyChair {
        //로컬 변수를 위해 스토리지 타입 대신 메모리 타입 사용
        require(! voters[voter].voted);
        voters[voter].weight = 1;
        // voters[voter].voted = false
    }

}


function vote(uint toProposal) public validPhase(Phase.Vote){
    Voter memory sender = voters[msg.sender];
    require (!sender.voted);
    require (toProposal < proposals.length);
    sender.voted = true;
    HYPERLINK "http//sender.vote/"sender.vote = toProposal;
    proposals[toProposal].voteCount += sender.weight;
}

function reqWinner() public validPhase(Phase.Done) view 
returns (uint winningProposal){
    uint winningVoteCount = 0;
    for(uint prop = 0; prop < proposals.length; prop++){
        if(proposals[prop].voteCount > winningVoteCount){
            winningVoteCount = proposals[prop].voteCount;
            winningProposal = prop;
        }
    }
    assert(winningVoteCount>=3);
}




