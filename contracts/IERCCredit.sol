// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERCCredit {


    event UpdatedCurrentSupply(uint256 amount, uint256 time);
    event BurnCreditsPublic(address indexed user, uint256 amount, uint256 sharesBalance);
    event BurnCreditsInternal(address indexed to, uint256 amount);

    function updateCurrentSupply(uint256 amount) external;
    function burnCreditsPublic() external;
    function calculateRewards(uint256 number) external view returns (uint256);
    function doesUserExist(address user) external view returns (bool);
}
