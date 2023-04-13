// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IERCNFT.sol";
import "./IERCToken.sol";



contract creditContract is ERC20, ERC721Holder{

    IERCNFT public nft;
    address public nftAddress;
    IERCToken public sharesContract;

    uint256 public _cap;
    uint256 public _capProgress;
    uint256 public _currentSupply = 0;
    uint256 private _fixedCurrentSupply = 0;
    address owner;
    uint256 public lastCalled;



    address [] userEntries;




    constructor(address _sharesAddress, uint256 cap) ERC20("AxonCarbonToken", "ACT"){
        owner = msg.sender;
        // nft = IERC721(_nft);
        lastCalled = 0;
        sharesContract = IERCToken(_sharesAddress);
        _cap = cap;
    }


    modifier _oncePerYear() {
        uint256 currentTime = block.timestamp;
        uint256 oneYearInSeconds = 365 days;

        // If lastCalled is 0 or more than one year has passed
        if (lastCalled == 0 || currentTime - lastCalled >= oneYearInSeconds) {
            _;
            // Update lastCalled to the current time
            lastCalled = currentTime;
        } else {
            revert("Function can only be called once per year");
        }
    }


    modifier _openCap(){
        require(_cap > _capProgress, "This project maximum supply had been reached");
        _;
    }
    modifier _onlyProjectContract(){
        require(msg.sender == nftAddress, "Not a project Owner!");
        _;
    }  

    event UpdatedCurrentSupply(uint256 _amount, uint256 _time);
    event BurnCreditsPublic(address indexed user, uint256 amount, uint256 sharesBalance);
    event BurnCreditsInternal(address indexed to, uint256 amount);


    function updateCurrentSupply(uint256 _amount) external   _oncePerYear  {

        if(_currentSupply > 0){
            _transfer(address(this), owner, _amount);
            _burn(owner, _amount);
            emit BurnCreditsInternal(owner, _amount);
            _mint(address(this), _amount);
            delete userEntries;

        }else{
            _mint(address(this), _amount);

        }

        _capProgress += _currentSupply;
        _currentSupply = _amount;
        _fixedCurrentSupply = _amount;
        emit UpdatedCurrentSupply(_amount, block.timestamp);


    }



    function burnCreditsPublic() public _openCap() {
        uint256 balance = sharesContract.balanceOf(msg.sender);
        require(balance >= 10, "You don't have enough shares");
        require(DoesUserExist(msg.sender) == false, "You have already claimed your rewards for this year!");

        uint256 creditsRewards = calculateRewards(balance);

        _transfer(address(this), msg.sender, creditsRewards);
        _burn(msg.sender, creditsRewards);
        userEntries.push(msg.sender);
        _currentSupply -= creditsRewards;

        emit BurnCreditsPublic(msg.sender, creditsRewards, balance);
        
    }

    function calculateRewards(uint256 _number) public view  returns (uint256) {
        require(_currentSupply != 0, "Total cannot be zero");
        uint256 creditsRewards = (_fixedCurrentSupply / 100) * _number;
        return creditsRewards;
    }



    function DoesUserExist(address _user) public view returns (bool) {
        for (uint256 i = 0; i < userEntries.length; i++) {
            if (userEntries[i] == _user) {
                return true;
            }
        }
        return false;
    }



}
