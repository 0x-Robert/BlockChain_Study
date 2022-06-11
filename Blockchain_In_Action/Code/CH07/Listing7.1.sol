pragma solidity >=0.4.24 <0.7.0;

contract MPC {
    address payable public sender;
    address payable public recipient;
    constructor (address payable recipientAddress)
        public
        payable
    {
        sender = msg.sender;
        recipient = recipientAddress;
    }

    function isValidSignedMessage(uint256 amount, bytes memory signedMessage)
        internal
        view
        returns (bool)
    {
        bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));
        return recoverSigner(message, signedMessage) == sender;
    }

    function claimPayment(uint256 amount, bytes memory signedMessage) public{
        require(msg.sender == recipient,'Not a recipient');
        require(isValidSignedMessage(amount, signedMessage),'Signed message Unmatch');
        require(address(this).balance > amount,'Insufficient Funds');
        recipient.transfer(amount);
        selfdestruct(sender);
    }

    function splitSignedMessage(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65,'Signed message length');
        assembly{
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignedMessage(sig);
        return ecrecover(message, v, r, s);
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}