// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


interface IERCToken is IERC20 {

    function setMinterNFT(address _sender, address _nft, uint256 _tokenId) external;

}