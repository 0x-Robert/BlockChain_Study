interface ERC721  { /// * ERC165이다. */

    event Transfer (address indexed _from, address indexed _to , uint256 _deedId);
    event Aproval(address indexed _owner , address indexed _approved,
                  uint256 _deedId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner ) external view returns (uint256 _balance);
    function ownerOf(uint256 _deedId) external view returns (address _owner);
    function transfer(address _to, uint256 _deedId) external payable;
    function transferFrom(address _from , address _to, uint256 _deedId) external payable;
    function approve(address _approved, uint256 _deedId) external payable;
    function setApprovalForAll(address _operateor, boolean _approved) payable;
    function supportsInterface(bytes4 interfaceID) external view returns(bool);
}


interface ERC721Metadata // ERC721이다. (메타데이터에 대한 선택적인터페이스 )
{
    function name() external pure returns (string _name);
    function symbol() external pure returns (string _symbol);
    function deedUri(uint256 _deedId) external view returns (string _deedUri);
}


// 열거를 위한 ERC721 선택적 인터페이스
interface ERC721Enumerable // ERC721
{
    function totalSupply() external view returns (uint256 _count);
    
    function deedByIndex(uint256 _index) external view returns (uint256 _deedId);
    function countOfOwners() external view returns (uint256 _count);
    function ownerByIndex(uint256 _index) external view returns (address _owner);
    function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);


}