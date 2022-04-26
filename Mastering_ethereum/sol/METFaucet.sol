//이프로그램을 작성한 솔리디티 컴파일러 버전

pragma solidity ^0.4.19;

import 'zepplin-solidity/contracts/token/ERC20/StandardToken.sol';


//ERC20 토큰 MET를 위한 Faucet

contract METFaucet {

    StandardToken public METoken;
    address public METOwner;


    //METFaucet 생성자는 METoken 컨트랙트의 주소와
    //우리가 transferFrom할 수 있는 소유자의 주소
    function METFaucet(address _METoken, address _METOwner) public {

        //제공된 주소로부터 METoken을 초기화
        METoken = StandardToken(_METoken);
        METOwner = _METOwner;

    }

    function withdraw(uint withdraw_amount) public {
        //출금양을 10MET로 제한
        require(withdraw_amount <= 1000);

        //METoken의 transferFrom 함수를 사용
        METoken.transferFrom(METOwner, msg.sender, withdraw_amount);

    }

    //들어오는 모든 이더 거부
    function () public payable { revert() ; }
}