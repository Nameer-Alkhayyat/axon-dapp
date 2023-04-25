// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


interface IShares is IERC20 {

    
    function setMinterNFT(address _sender, address _nft, uint256 _tokenId) external;
    function buyShares(uint256 shares) external payable returns (bool);
    function transferShares(address to, uint256 shares) external returns (bool);
    function getShares() external view returns (uint256);
    function getPrice(uint256 _amount) external view returns (uint256);

}