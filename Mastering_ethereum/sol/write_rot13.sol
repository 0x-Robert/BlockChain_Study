import "Rot13Encryption.sol";

// 일급 비밀 정보 암호화
contract EncryptionContract {
    //암호화 라이브러리
    Rot13Encryption encryptionLibrary;

    //생성자 - 라이브러리를 초기화한다.
    constructor (Rot13Encryption _encryptionLibrary){
        encryptionLibrary = _encryptionLibrary;
    }

    function encryptPrivateData(string privateInfo){
        //잠재적으로 여기서 몇가지 작업을 수행한다.
        encryptionLibrary.rot13Encrypt(privateInfo);
    }
}