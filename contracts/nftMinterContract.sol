// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IERCToken.sol";



contract nftMinterContract is ERC721URIStorage, Ownable{
    IERCToken public sharesContractAddress;
    bool  public shareContractExsist = false;
    address landOwner;

    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    constructor(address _landOnwer, address _sharesAddress)ERC721("DE-NFT", "DENFT"){
        landOwner = _landOnwer;
        sharesContractAddress = IERCToken(_sharesAddress);
        shareContractExsist = true;


    }
    modifier _onlyLandOnwer(){
        require(msg.sender == landOwner, "Not a land Onwer!");
        _;
    }   

    function mintToken(string memory tokenURI ) external returns(uint256){
        require(shareContractExsist, "Shares contract is still yet to be deployed");
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        stakeDENFT(msg.sender, tokenId);
        return tokenId;
    }


    function stakeDENFT(address _sender,  uint256 _tokenId) internal {
   
        sharesContractAddress.setMinterNFT(_sender, address(this), _tokenId);


    }

}