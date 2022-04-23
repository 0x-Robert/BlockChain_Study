// 라이브러리 컨트랙트 - 피보나치 같은 수를 계산한다.

contract FibonacciLib {


    // 표준 피보나치 수열 초기화
    uint public start;
    uint public calculatedFibNumber;

    //수열에서 0번째 수 수정하기
    function setStart(uint _start) public {
        start = _start; 
    }

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }

    function fibonacci(uint n) internal returns (uint){
        if (n == 0) return start;
        else if (n == 1 ) return start + 1;
        else return fibonacci(n-1) + fibonacci(n-2);
    }
}