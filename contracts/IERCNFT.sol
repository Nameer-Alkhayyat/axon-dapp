// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";



interface IERCNFT is IERC721  {

    
    function mintToken(string memory tokenURI )  external returns(uint256);

    // function to update oracle address by Axon

    function updateOracleAddress(address _oracle ) external;


    // functio to update yearly actualCarbonCredit by Oracle

    function updateCurrentSupply(uint256 _amount) external returns(bool);

    // functio to update yearly maxCarbonCredit and minCarbonCredit by Oracle

    function updateCarbonEstimation(uint256 _min, uint256 _max) external;



    function getShares() external view returns (uint256);
    function getPrice() external view returns (uint256);
    
}