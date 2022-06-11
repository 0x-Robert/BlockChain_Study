pragma solidity ^0.5.8;
// import "../../res4-app/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./helper_contracts/ERC721.sol";

contract RES4 is ERC721{
    struct Asset{
        uint256 assetId;
        uint256 price;
    }

    uint256 public assetsCount;
    mapping(uint256 => Asset) public assetMap;
    address public supervisor;
    mapping (uint256 => address) private assetOwner;
    mapping (address => uint256) private ownedAssetsCount;
    mapping (uint256 => address) public assetApprovals;
    constructor()public {
        supervisor = msg.sender;
    }

    //Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    ////////////////////////////////////////////////////////////////////////////////
                // ERC721 functions //
   ////////////////////////////////////////////////////////////////////////////////

    function balanceOf() public view returns (uint256) {
        require(msg.sender != address(0), "ERC721: balance query for the zero address");

        return ownedAssetsCount[msg.sender];
    }

    function ownerOf(uint256 assetId) public view returns (address) {
        address owner = assetOwner[assetId];
        require(owner != address(0), "NoAssetExists");
        return owner;
    }
    function transferFrom(address payable from, uint256 assetId) public payable {
        require(isApprovedOrOwner(msg.sender, assetId), "NotAnApprovedOwner");
        require(ownerOf(assetId) == from, "NotTheassetOwner");
        clearApproval(assetId,getApproved(assetId));
        ownedAssetsCount[from]--;
        ownedAssetsCount[msg.sender]++;
        assetOwner[assetId] = msg.sender;
        from.transfer(assetMap[assetId].price * 1000000000000000000);
        emit Transfer(from, msg.sender, assetId);
    }

    function approve(address to,uint256 assetId) public {
        address owner = ownerOf(assetId);
        require(to != owner, "CurrentOwnerApproval");
        require(msg.sender == owner,"NotTheAssetOwner");
        assetApprovals[assetId] = to;
        emit Approval(owner, to, assetId);
    }

    function getApproved(uint256 assetId) public view returns (address) {
        require(exists(assetId), "ERC721: approved query for nonexistent token");
        return assetApprovals[assetId];
    }

    ////////////////////////////////////////////////////////////////////////////////
                // Additional functions added to the  token //
   ////////////////////////////////////////////////////////////////////////////////

    function addAsset(uint256 price,address to) public{
        require(supervisor == msg.sender,'NotAManager');
        assetMap[assetsCount] = Asset(assetsCount,price);
        mint(to,assetsCount);
        assetsCount = assetsCount+1;
    }
    function clearApproval(uint256 assetId,address approved) public {
        if (assetApprovals[assetId]==approved){
            assetApprovals[assetId] = address(0);
        }
    }

    function build(uint256 assetId,uint256 value) public payable{
        require(isApprovedOrOwner(msg.sender, assetId), "NotAnApprovedowner");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price+value);
    }
        function appreciate(uint256 assetId,uint256 value) public{
        require(msg.sender==supervisor,"NotaManager");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price+value);
    }
        function depreciate(uint256 assetId,uint256 value) public{
        require(msg.sender==supervisor,"NotaManager");
         Asset memory oldAsset = assetMap[assetId];
         assetMap[assetId] = Asset(oldAsset.assetId, oldAsset.price-value);
    }
    function getAssetsSize() public view returns(uint){
        return assetsCount;
    }
    ////////////////////////////////////////////////////////////////////////////////
                // Functions used internally by another functions //
   ////////////////////////////////////////////////////////////////////////////////

    function mint(address to, uint256 assetId) internal {
        require(to != address(0), "ZeroAddressMiniting");
        require(!exists(assetId), "AlreadyMinted");
        assetOwner[assetId] = to;
        ownedAssetsCount[to]++;
        emit Transfer(address(0), to, assetId);
    }
    function exists(uint256 assetId) internal view returns (bool) {
        return assetOwner[assetId] != address(0);
    }

    function isApprovedOrOwner(address spender, uint256 assetId) internal view returns (bool) {
        require(exists(assetId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(assetId);
        return (spender == owner || getApproved(assetId) == spender);
    }

   ////////////////////////////////////////////////////////////////////////////////
                // Unused ERC721 functions //
   ////////////////////////////////////////////////////////////////////////////////
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
        function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }
        function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
}