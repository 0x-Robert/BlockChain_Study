contract FibonacciBalance {



    address public fibonacciLibrary;
    //출금할 현재 피보나치 수
    uint public calculatedFibNumber;
    
    //피보나치 수열의 시작 번호
    uint public start = 3;
    uint public withdrawalCounter;

    //피보나치 함수 선택자
    bytes4 constant fibSig = bytes4(sha3("setFibonacci(uint256)"));

    //생성자 - 이더와 함께 컨트랙트 불러오기
    constructor(address _fibonacciLibrary) public payable {
        fibonacciLibrary = _fibonacciLibrary;
    }

    function withdraw(){
        withdrawalCounter += 1;
        //현재 출금자를 위한 피보나치 수 계산하기
        
        //이것으로 calculatedFibNumber를 할당한다.
        require(fibonacciLibrary.delegatecall(fibSig, withdrawalCounter));
        msg.sender.transfer(calculatedFibNumber * 1 ether)



    }

    // 피보나치 라이브러리 함수 호출 허용하기
    function() public {
        require(fibonacciLibrary.delegatecall(msg.data));
    }









}