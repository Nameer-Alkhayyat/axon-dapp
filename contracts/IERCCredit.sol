// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERCCredit  is IERC20 {


    function updateCurrentSupply(uint256 amount) external;
    function burnCreditsPublic() external;
    function calculateRewards(uint256 number) external view returns (uint256);
    function doesUserExist(address user) external view returns (bool);
}
