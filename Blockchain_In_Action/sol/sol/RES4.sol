pragma solidity >=0.4.22 <=0.6.0;
import "./helper_contracts/ERC721.sol";

contract RES4 is ERC721 {
    struct Asset {
        uint256 assetId;
        uint256 price;
    }

    uint256 public assetsCount;
    //토큰 관리를 위한 해시 테이블/파이썬으로 치면 딕셔너리
    mapping(uint256 => Asset) public assetMap;
    address public supervisor;
    mapping(uint256 => address) private assetOwner;
    mapping(address => uint256) private ownedAssetsCount; 
    mapping (uint256 => address) public assetApprovals;

    //이벤트들
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    constructor() public{
        supervisor = msg.sender;
    }

    //ERC721 함수들 RES4가 사용하는 ERC721 함수
    function balanceOf() public view returns (uint256) {}
    function ownerOf(uint256 assetId) public view returns (address) {}
    function transferFrom(address payable from, uint256 assetId) {}
    function aprove(address to, uint256 assetId) public {}
    function getApproved(uint256 assetId) returns (addrss) {}

    //RES4 토큰을 위해 추가한 함수들 RES4 Dapp에 특정한 함수
    function addAsset(uint256 price, address to) public {}
    function clearApproval(uint256 assetId, address approved) public{}
    function build(uint256 assetId, uint256 value) public payable {}
    function appreciate(uint256 assetId, uint256 value) public {}
    function depreciate(uint256 assetId, uint256 value) public {}
    function getAssetsSize() public view returns(uint) {}

    //내부적으로 사용되는 함수
    function mint(address to, uint256 assetId) internam {}
    function exists(uint256 assetId) internal view returns (bool) {}
    function isApprovedOrOwner(address spender, uint256 assetId) {}
    //준수를 위한 다른 ERC721 함수들
     

     

}
