//언더플로/오버플로 취약점을 방지하기 위한 현재의 일반적인 기술은 표준 수학 연산자인 더하기,빼기,곱셈을 대체하는 수학 라이브러리를 사용하거나 만드는 것이다.
// 오픈제플린(OpenZeppelin, https://bit.ly/2RJoRvL)은 이더리움 커뮤니티를위한 보안 라이브러리를 구축하고 감사하는 훌륭한 작업을 수행했다. 특히 SafeMath 라이브러리는 
// 언더플로/오버플로 취약점을 방지하는 데 사용할 수 있다. 
// SafeMath라이브러리를 사용하여 TimeLock 컨트랙트를 수정해보자.


library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0 ){
            return 0;
        }
        uint256 c = a * b
        assert(c / a == b );
        return c;

    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // 0으로 나눌 때 솔리디티는 자동으로 던진다.
        uint256 c = a / b;
        // assert(a == b * c + a % b); //이것은 모든 경우에 적용된다.
        return c ;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract TimeLock {
    using SafeMath for uint ; //uint 타입용 라이브러리 사용하기
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value)
        lockTime[msg.sender] = now.add(1 weeks);
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }

    function withdraw() public{
        require(balances[msg.sender] > 0);
        require(now > lockTime[msg.sender]);
        balances[msg.sender] = 0;
        msg.sender.transfer(balance);

    }
}
