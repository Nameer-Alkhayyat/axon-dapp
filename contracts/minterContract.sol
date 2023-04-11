// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IERCToken.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract nftMinterContract is ERC721URIStorage, Ownable{

    enum  projectState {
        initated,
        allOk,
        naturalDisaster,
        landOwnerIssue,
        paused
    }
    projectState public state = projectState.initated;


    IERCToken public sharesContract;
    address private sharesContracAddress;
    address private Oracle;
    address landOwner;
    uint256 public price;

    bool  public shareContractExsist = false;
    uint256 constant maxSupply = 1;
    uint256 public numberOfShares;

    uint256 public currentSupply;
    uint256 public maxCarbonCredit;
    uint256 public minCarbonCredit;


    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    mapping(address => uint256) lastCalled;
    uint256 timeInterval = 1 hours;

    constructor(address _landOnwer, address _sharesAddress, address _oracle, uint256 _shares, uint256 _price)ERC721("DE-NFT", "DENFT"){
        landOwner = _landOnwer;
        Oracle = _oracle;
        sharesContract = IERCToken(_sharesAddress);
        shareContractExsist = true;
        numberOfShares = _shares;
        price = _price;
    }


    modifier _onlyLandOwner(){
        require(msg.sender == landOwner, "Not a land Onwer!");
        _;
    }   
    modifier _onlyOracle(){
        require(msg.sender == Oracle, "Not an Oracle!");
        _;
    }   

    modifier _checkState(projectState _state) {
        require(state == _state);
        _;
    }


    event oracleUpdateErorr(uint256 _amount, address _oracle, uint _time);



    function mintToken(string memory tokenURI ) _onlyLandOwner _checkState(projectState.initated) external returns(uint256) {
        require(shareContractExsist, "Shares contract is still yet to be deployed");
        require(_tokenIds.current() == 0, "Max supply had been reached.");
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        stakeNFT(msg.sender, tokenId);
        return tokenId;
    }


    function stakeNFT(address _sender,  uint256 _tokenId) internal {
   
        sharesContract.setMinterNFT(_sender, address(this), _tokenId);

    }

    // function to update oracle address by Axon

    function updateOracleAddress(address _oracle ) external onlyOwner{
        Oracle = _oracle;
        
    }


    // functio to update yearly actualCarbonCredit by Oracle

    function updateCurrentSupply(uint256 _amount) external _onlyOracle _checkState(projectState.allOk) returns(bool)  {

             // define, define how many times an oracle can call the contract: Only once per 356 day
        require(block.timestamp >= lastCalled[msg.sender] + timeInterval, "Function can only be called once per  hour");
        if(_amount < minCarbonCredit || _amount > maxCarbonCredit ){
            currentSupply = 0;
            state = projectState.paused;
            emit oracleUpdateErorr(_amount, msg.sender, block.timestamp);
            return false;

        }else {

            currentSupply = _amount;
            lastCalled[msg.sender] = block.timestamp;
            return true;
        }
   
    }

    // functio to update yearly maxCarbonCredit and minCarbonCredit by Oracle

    function updateCarbonEstimation(uint256 _min, uint256 _max) external _onlyOracle _checkState(projectState.allOk) {
        require(_min > 0, "Erorr");
        require(_max > 0, "Erorr");
        maxCarbonCredit = _max;
        minCarbonCredit = _min;
        
    }

    // function to update the current NFT price.

    function updateCurrentPrice( uint256 _price) external onlyOwner _checkState(projectState.allOk){
        // some calulation
        price = _price;

        
    }

    // function to update the project state after investigation by Axon
    function setStateOk() public onlyOwner {
        state = projectState.allOk;   
    }
    function setStateNaturalDisaster() public onlyOwner {
        state = projectState.naturalDisaster;   
    }
    function setStateLandOwnerIssue() public onlyOwner {
        state = projectState.landOwnerIssue;   
    }
    function setStatePaused() public onlyOwner {
        state = projectState.paused;   
    }

    function getShares() external view returns (uint256) {
        return numberOfShares;
        
    }
    function getPrice() external view returns (uint256) {
        return price;
        
    }




    // define a brige to the teasuery to transfer money or not, based on the project State.







//    function _beforeTokenTransfer(
//         address from,
//         address to,
//         uint256 tokenId
//     ) internal virtual override {
//         super._beforeTokenTransfer(from, to, tokenId,1);

//         require(to == sharesContracAddress, "Revert:Unknown address");

//         uri = tokenId;
//         // do stuff before every transfer
//         // e.g. check that vote (other than when minted) 
//         // being transferred to registered candidate
//     }

}


