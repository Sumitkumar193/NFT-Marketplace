// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

//Metadata is the extension of contracts

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

contract ERC721Metadata is IERC721Metadata, ERC165 {

    string private _name;
    string private _symbol;

    constructor(string memory _parsedName, string memory _parsedInfo){
        _name = _parsedName;
        _symbol = _parsedInfo;
        _registerInterface(bytes4(keccak256('name(bytes4)')^keccak256('symbol(bytes4)')));  //register interfaces of erc721Metadata
    }

    function name() external view override returns(string memory) {
        return _name;
    }

    function symbol() external view override returns(string memory) {
        return _symbol;
    }

}