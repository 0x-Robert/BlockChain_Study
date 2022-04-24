//암호화 컨트랙트
// ROT13 암호를 구현한 코드
// 이 코드는 문자열(유효성 겁사없이 문자a~z)을 가져와서 각 문자를 오른쪽으로 13칸 이동하여 암호화한다. 즉 a는  n이되고, x는 k가 된다.

contract Rot13Encryption {

    event Result(string convertedString);

    //rot13 - 문자열 암호화
    function rot13Encrypt (string text) public {
        uint256 length = bytes(text).length;
        for (var i = 0; i < length; i++){
            byte char = bytes(text)[i];
            //문자열을 수정하는 인라인 어셈블리
            assembly {
                //첫번째 바이트를 얻기
                char := byte(0,char)
                // 문자가 [n,z]에 있는 경우, 즉 래핑
                if and(gt(char, 0x6D), lt(char,0x7B))
                //ASCII 숫자 a에서 빼기
                //문자 <char>와 z의 차이
                {char := sub(0x60, sub(0x7A, char))}
                if iszero(eq(char,0x20)) //공백 무시
                // char에 13을 더하기
                {mstore8(add(add(text,0x20), mul(i,1)), add(char,13))}
            }
        }
        emit Result(text);
    }

    // rot13 - 문자열 해독
    function  rot13Decrypt (string text) public {
        uint256 length = bytes(text).length; 
        for(var i = 0; i < length; i++){
            byte char = bytes(text)[i];
            assembly {
                char := byte(0,char)
                if and(gt(char, 0x60), lt(char,0x6E))
                { char := add(0x7B, sub(char,0x61))}
                if iszero(eq(char, 0x20))
                {mstore8(add(add(text, 0x20), mul(i,1)), sub(char,13) )}
            }
        }
        emit Result(text);
    }


}


