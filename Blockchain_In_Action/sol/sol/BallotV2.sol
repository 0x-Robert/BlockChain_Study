pragma solidity >=0.4.2 =<0.6.0;
contract BallotV1 {

    struct Voter{
        uint weight;
        bool voted; //Voter타입은 투표자 상세 정보를 담고 있다.
        uint vote;
    }

    struct Proposal {
        uint voteCount; // Proposal 타입은 제안의 상세 정보를 담고 있는데, 현재는 voteCount만을 가지고 있다.
    }

    address chairperson;
    mapping(address => Voter) voters; //투표자 주소를 투표자 상세 정보로 매핑
    Proposal[] proposals; 

    enum Phase {Init, Regs, Vote, Done} // 투표의 여러 단계(0,1,2,3)을 나타내고, init 단계로 상태가 초기화 된다.
    Phase public state = Phase.Init; 

enum Phase {Init , Regs , Vote , Done} //내부적으로 0,1,2,3으로 코딩된다.
//단계는 오직 0,1,2,3 값만 가질 수 있고 , 다른 값은 모두 무효다.


Phase public state = Phase.Init;


constructor (uint numProposals) public { //constructor는 컨트랙트 배포자로서 의장을 설정한다.
    chairperson = msg.sender; 
    voters[chairperson].weight = 2; //테스트를 위해 가중치를 2로 설정 
    for (uint prop = 0; prop < numProposals; prop ++){
        proposals.push(Proposal(0));
    }
    //제안 개수는 constructor의 파라미터다.
}

function changeState(Phase x ) public { //상태 변화 함수 
    if(msg.sender != chairperson) revert(); //오직의장만이 상태를 바꿀 수 있으며, 그렇지 않을 경우 되돌린다.
    if (x < state) revert(); 
    state=x; //state는 0,1,2,3 순서대로 진행하며, 그렇지 않을 경우 되돌린다.
}

}
