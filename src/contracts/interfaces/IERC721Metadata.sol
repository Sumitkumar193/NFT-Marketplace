// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IERC721Metadata /* is ERC721 */ {
    function name() external view returns (string memory name);

    function symbol() external view returns (string memory symbol);

//function tokenURI(uint256 _tokenId) external view returns (string memory);
}