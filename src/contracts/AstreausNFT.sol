// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './Connector.sol';

contract Astreaus is ERC721Connector {
    string[] public AstreausNFTs;   //Array for storing tokens/nft
    mapping(string => bool) private _infoExists;

    constructor() ERC721Connector("Astreaus", "ASX") {
        // Note:USE CONTRACT NAME IN TRUFFLE DEVELOPMENT!
    }

    function mint(string memory _infos) public {
        require(!_infoExists[_infos] ,"AstreausNFT: Info is already exists"); //Check if info exists
        AstreausNFTs.push(_infos);
        uint _id = AstreausNFTs.length - 1;        
        _mint(msg.sender, _id);
        _infoExists[_infos] = true;                             //Push infos into map
    }

}