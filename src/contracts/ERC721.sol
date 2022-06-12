// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721{

    mapping(uint => address) private _tokenOwner;       //Token owner by address (if a user has created multiple tokens)
    mapping(address => uint) private _ownedTokensCount;  //Tokens owned by address
    mapping(uint => address) private _tokenApprovals;   //Map of tokenID to approved address

    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    function _mint(address _to , uint _tokenId) internal virtual {

        require(_to != address(0), "Minting to Invalid Address");
        require(_check(_tokenId),"Token already minted!");
        _tokenOwner[_tokenId] = _to;
        _ownedTokensCount[_to] += 1;

        emit Transfer(address(0), _to, _tokenId);   //By default 0 for minter
    }

    modifier check(address _checkAddress, uint _tokenId){
        require(_checkAddress != address(0x0), "ERC721: Invalid Address!"); //Use address(0) to compare to an address else uint 
        require(_check(_tokenId),"ERC721: Token already exists!");
        _;
    }

    function _check(uint _tokenId) internal view returns(bool){
        address _checkAddress = _tokenOwner[_tokenId];
        //Map will output 0 if the _tokenId does not exists
        //True if 0 and False if the token has owner address
        if(_checkAddress != address(0)){
            return false;
        }else{
            return true;
        }
    }

    function balanceOf(address _owner) public override view returns(uint){
        require(_owner != address(0),"ERC721: Invalid Address!");
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint _tokenId) public view override returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: Invalid Query for tokens");
        return owner;
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "ERC721 - You are not the owner of this token!");
        require(_to != address(0), "ERC721 - Sending token to an invalid address");
        _ownedTokensCount[_from] -= 1;  //Deduction from current owner
        _ownedTokensCount[_to] += 1;    //Addition to new owner
        _tokenOwner[_tokenId] = _to;    
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from,address _to,uint _tokenId) override public {
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint tokenId) override public {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender, "Err-Approval-01: You are not the owner of token!");
        require(owner != _to, "Err-Approval-02:You cannot approve to your own address!");
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

}