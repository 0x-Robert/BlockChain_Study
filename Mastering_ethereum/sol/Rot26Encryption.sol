//암호화 컨트랙트
//이 컨트랙트는 각 문자를 26자리만큼 이동시키는 ROT26 암호를 구현한다. (즉 아무것도 하지 않는다. )

contract Rot26Encryption {
    event Result(string convertedString);

    // rot13 문자열 암호화
    function rot13Encrypt (string text) public {
        uint256 length = bytes(text).length;
        for (var i = 0; i < length; i++){
            byte char = bytes(text)[i];
            //문자열을 수정하는 인라인 어셈블리
            assembly {
                //첫 번쨰 바이트를 얻기
                char := byte(0,char)
                // 문자가 [n,z]에 있는 경우, 즉 래핑
                if and(gt(char, 0x6D) , lt(char,0x7B))
                //ASCII 숫자 a에서 뺴기,
                // 문자 <char>와 z의 차이
                {char := sub(0x60, sub(0x7A, char))}
                //공백 무시
                if iszero(eq(char, 0x20))
                // char에 26을 더하기
                {mstore8(add(add(text,0x20), mul(i,1)) , add(char,26))}
            }
        }
        emit Result(text);

    }


    //rot13 문자열 해독
    function rot13Decrypt (string text) public {
        uint256 length = bytes(text).length;
        for (var i = 0; i < length; i++){
            byte char = bytes(text)[i];
            assembly {
                char := byte(0,char)
                if and(gt(char, 0x60), lt(char,0x6E))
                { char := add(0x7B, sub(char,0x61))}
                if iszero(eq(char, 0x20))
                {mstore8(add(add(text,0x20), mul(i,1)), sub(char,26) )}


            }
        }
        emit Result(text);
    }
}