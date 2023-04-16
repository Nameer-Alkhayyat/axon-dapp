// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IERCNFT.sol";
import "./IERCToken.sol";

contract CreditContract is ERC20 {
    // state variables
    IERCNFT public nft;
    IERCToken public sharesContract;
    address public nftAddress;
    address public owner;
    address[] private userEntries;
    uint256 public cap;
    uint256 public capProgress;
    uint256 public currentSupply = 0;
    uint256 private fixedCurrentSupply = 0;
    uint256 public lastCalled;

    // events
    event UpdatedCurrentSupply(uint256 amount, uint256 time);
    event BurnCreditsPublic(address indexed user, uint256 amount, uint256 sharesBalance);
    event BurnCreditsInternal(address indexed to, uint256 amount);

    // constructor
    constructor(address sharesAddress, address _nftAdress, uint256 _cap) ERC20("AxonCarbonToken", "ACT") {
        owner = msg.sender;
        lastCalled = 0;
        sharesContract = IERCToken(sharesAddress);
        nftAddress = _nftAdress;
        cap = _cap;
    }

    // modifiers
    modifier oncePerYear() {
        uint256 currentTime = block.timestamp;
        uint256 oneYearInSeconds = 365 days;

        require(lastCalled == 0 || currentTime - lastCalled >= oneYearInSeconds, "Function can only be called once per year");
        _;
        lastCalled = currentTime;
    }

    modifier openCap() {
        require(cap > capProgress, "This project maximum supply had been reached");
        _;
    }

    modifier onlyProjectContract() {
        require(msg.sender == nftAddress, "Not a project Owner!");
        _;
    }

    // external functions
    function updateCurrentSupply(uint256 amount) external   oncePerYear {
        if (currentSupply > 0) {
            _transfer(address(this), owner, amount);
            _burn(owner, amount);
            emit BurnCreditsInternal(owner, amount);
            _mint(address(this), amount);
            delete userEntries;
        } else {
            _mint(address(this), amount);
        }

        capProgress += currentSupply;
        currentSupply = amount;
        fixedCurrentSupply = amount;
        emit UpdatedCurrentSupply(amount, block.timestamp);
    }

    // public functions
    function burnCreditsPublic() public openCap {
        uint256 balance = sharesContract.balanceOf(msg.sender);
        require(balance >= 10, "You don't have enough shares");
        require(!doesUserExist(msg.sender), "You have already claimed your rewards for this year!");

        uint256 creditsRewards = calculateRewards(balance);

        _transfer(address(this), msg.sender, creditsRewards);
        _burn(msg.sender, creditsRewards);
        userEntries.push(msg.sender);
        currentSupply -= creditsRewards;

        emit BurnCreditsPublic(msg.sender, creditsRewards, balance);
    }

    // view functions
    function calculateRewards(uint256 number) public view returns (uint256) {
        require(currentSupply != 0, "Total cannot be zero");
        return (fixedCurrentSupply / 100) * number;
    }

    function doesUserExist(address user) public view returns (bool) {
        for (uint256 i = 0; i < userEntries.length; i++) {
            if (userEntries[i] == user) {
                return true;
            }
        }
        return false;
    }
}
