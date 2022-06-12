// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721.sol';

import './interfaces/IERC721Enum.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable{

    uint[] private _allTokens;

    mapping(uint => uint) private _allTokensIndex;        //Position of tokens in _allTokens array by _tokenId

    mapping(address => uint[]) private _ownedTokens;      //Map of owner addresses to list of owned tokens

    mapping(uint => uint) private _ownedTokensIndex;       //Map for owned tokens from _ownedTokens map

    constructor(){
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^ keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));   //register interfaces of erc721enum
    }


    function totalSupply() override public view returns (uint256){
        return _allTokens.length;                               //return A count of valid NFTs tracked by this contract
    }

    function tokenByIndex(uint256 _index) public view override returns (uint256){            //Returns token by Index from _allTokens
        require(_index <= totalSupply(), "ERC721Enum: Index is out of bounds!");
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) override public view returns (uint256){
        require(_index < balanceOf(_owner) && _owner != address(0),
        "ERC721Enum: Index of owned tokens is out of bounds OR Invalid address is provided");   //^^ Conditions if index is greater than balance of owner and invalid address
        return _ownedTokens[_owner][_index];
    }

    function _mint(address _to,uint  _tokenId) override(ERC721) internal{
        super._mint(_to,_tokenId);
        addTokensToAllTokenEnumeration(_tokenId);(_tokenId);
        addTokensToOwnerEnumeration(_to, _tokenId);
    }

    function addTokensToOwnerEnumeration(address to, uint tokenId) private {
        _ownedTokens[to].push(tokenId);                          //Send token into array of owned tokens
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;    //Set Index of token for owned tokens list(array)
    }

    function addTokensToAllTokenEnumeration(uint _tokenId) private {
        _allTokensIndex[_tokenId] = _allTokens.length;      //Position of token at _allTokens
        _allTokens.push(_tokenId);                          //Push token into all tokens
    }
}