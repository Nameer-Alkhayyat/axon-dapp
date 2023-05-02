// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";



interface IMinter is IERC721  {
    function numberOfShares() external view returns(uint256);
    function price()external view returns(uint256);
    function mintToken(string calldata tokenURI, uint256 _shares) external returns (uint256);
    function updateOracleAddress(address _oracle) external;
    function updateCurrentSupply(uint256 _amount) external returns (bool);
    function updateCarbonEstimation(uint256 _min, uint256 _max) external;
    function setStateOk() external;
    function setStateNaturalDisaster() external;
    function setStateLandOwnerIssue() external;
    function setStatePaused() external;
}