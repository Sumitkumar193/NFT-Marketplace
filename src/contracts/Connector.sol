// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

//This contract is bridge between base contracts and Output smart contracts

import './Metadata.sol'; 
import './ERC721Enum.sol';

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {
    
    constructor(string memory name, string memory symbol) ERC721Metadata(name,symbol){
        
    }

}