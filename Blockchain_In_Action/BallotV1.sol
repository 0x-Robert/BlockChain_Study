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

}