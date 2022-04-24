//함수내의 지역변수는 타입에 따라 메모리지나 스토리지를 기본으로 사용한다.
// 초기화 되지 않은 로컬 스토리지 변수에는 컨트랙트의 다른 스토리지 변숫값이 포함 될 수 있다.

//잠긴 이름 등록자
contract NameRegister {
    bool public unlocked = false;
    //등록자가 잠김, 이름 업데이트 없음

    struct NameRecord {
        //해시를 주소로 매핑한다.
        bytes32 name;
        address mappedAddress;
    }

    //등록된 이름을 기록한다.
    mapping(address => NameRecord) public registeredNameRecord;
    //해시를 주소로 해석한다.
    mapping(bytes32 => address) public resolve;

    function register(bytes32 _name, address _mappedAddress) public {
        //새로운 NameRecord를 설정한다.
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress; 
       
        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord;
        require(unlocked); // 컨트랙트가 잠겨 있지 않을 때만 등록을 허용한다.
        
    }
}