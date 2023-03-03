// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract LandMangment is Ownable{

    // address public oracle;

    struct LandData {
        address minterContract;
        address assestOnwer;
        // address assestHolder;
        uint256 TokenID;
        bool approved;
        uint256 created_at;
        // uint256 expires_at;
        uint256 CurrentRewards;
        uint256 pastRewards;
    }

    constructor(){}

    mapping(address => LandData) public lands;


    function setLand  (
        address _assestOnwer,
        address _assestHolder,
        uint256 _TokenID) public {

        LandData storage _landData = lands[_assestHolder];
        _landData.assestOnwer = _assestOnwer; 
        _landData.TokenID = _TokenID;
        _landData.minterContract = msg.sender;
        _landData.approved = true;
        _landData.created_at = block.timestamp;
        _landData.CurrentRewards = 200;
        _landData.pastRewards = 0;
        }
    
    function updateCurrentReward(address _assestHolder, uint256 _currentRewards) public{

        LandData storage _landData = lands[_assestHolder];
        processCurrentRewards(_assestHolder);
        _landData.CurrentRewards = _currentRewards;
    }

    function processCurrentRewards(address _assestHolder) internal {
        LandData storage _landData = lands[_assestHolder];
        require(_landData.CurrentRewards > 0, "User Currently have no Carbon Credit Rewards, Oracle need to update user Current Rewards");
        // need an if statment. 
        uint256 _setPastRewards = _landData.CurrentRewards;
        _landData.pastRewards += _setPastRewards;
        _landData.CurrentRewards = 0;

    }

    function claimCurrentRewards(address _assestHolder, uint256 amount) external returns(uint256){
        uint256 claimedRewards = getCurrentRewards(_assestHolder);
        LandData storage _landData = lands[_assestHolder];
        require(claimedRewards > 0, "User Currently have no Carbon Credit Rewards, Oracle need to update user Current Rewards");
        require(claimedRewards >= amount , "User have less Carbon Creidt than the desired amount.");
        _landData.CurrentRewards -= amount;
        return claimedRewards;

    }
    function claimPastRewards(address _assestHolder, uint256 amount) external returns(uint256){

        LandData storage _landData = lands[_assestHolder];
        uint256 _claimedPastRewards = getPastRewards(_assestHolder);
        require(_claimedPastRewards > 0, "User Currently have no past Carbon Credit Rewards");
        require(_claimedPastRewards >= amount , "User have less Carbon Creidt than the desired amount.");
        _landData.pastRewards -= amount;
        return _claimedPastRewards;

    }
    

    function getCurrentRewards(address _assestHolder) public view returns(uint256){
        LandData storage _landData = lands[_assestHolder];
        return  _landData.CurrentRewards;
        
    }
    function getPastRewards(address _assestHolder) public view returns(uint256){
        LandData storage _landData = lands[_assestHolder];
        return  _landData.pastRewards;
    
    }







    
}