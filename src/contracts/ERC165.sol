// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor(){
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    function supportsInterface(bytes4 interfaceID) external override view returns (bool){
        return _supportedInterfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceID) internal {
        bytes4 errInterface = 0xffffffff;
        require(interfaceID != errInterface, "ERC165- Invalid InterfaceID");
        _supportedInterfaces[interfaceID] = true;
    }
}