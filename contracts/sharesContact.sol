// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IERCNFT.sol";
import "hardhat/console.sol";



contract sharesToken is ERC20, ERC721Holder{

    IERCNFT public nft;
    address public nftAddress;
    address public owner;
    uint256 public _totalSupply;
    uint256 remainingSupply;

    mapping(uint256 => address) public tokenOwnerOf;
    mapping(uint256 => bool) public isStaked;


    constructor() ERC20("AxonCarbonToken", "ACT"){
        owner = msg.sender;
    }

    modifier _onlyOwner(){
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function stake(address _sender, uint256 tokenId) internal {
        console.log("this is a sender", msg.sender);
        console.log("this is another sender", _sender);
        nft.safeTransferFrom(_sender, address(this), tokenId);
        tokenOwnerOf[tokenId] = msg.sender;
        isStaked[tokenId] = true;

    }

    function setMinterNFT(address _sender, address _nft, uint256 _tokenId) external{
        console.log("this is a sender", msg.sender);
        nft = IERCNFT(_nft);
        nftAddress = _nft;
        stake(_sender, _tokenId);
        setTotalSupply();

    }



    // function to mint the share as erc20 and transfer them to the buyer
    function setTotalSupply() internal {
       uint256 nrShares = getShares();
       uint256 _maxSupply = nrShares * 10;
       _totalSupply = _maxSupply;
       remainingSupply = _maxSupply;
        

    }

    function buyShares(uint256 shares) public payable returns (bool) {
        console.log("valuueueue",msg.value);
        require(shares >= 10, "Shares: too small");
        require(remainingSupply > 0, "no more share to mint");
        require(getPrice(shares) <= msg.value, "You don't have enough Eth");
        _mint(msg.sender, shares);
        // payable(nftAddress).transfer(msg.value);
        remainingSupply -= shares;
        return true;
        
    }

    function _transferShares(address to, uint256 shares) public  returns (bool) {
        require(shares >= 10, "Shares: too small");
        require(balanceOf(msg.sender) >= shares, "Shares: too small");
        transfer(to, shares);
        return true;
        
    }

    
    // function to figuer out the payable situation 
    // function to get the total amount of share from the
    
    function getShares() view public returns (uint256) {

       return  nft.getShares();
        
    }

    // function to get the tolatal price of the NFT and calculate the price of the share.
    function getPrice(uint256 _amount) view public returns (uint256) {

        uint256 projectPrice = nft.getPrice();
        uint256 pricePerShare = projectPrice/ _totalSupply;
        return pricePerShare * _amount;
        
    }


}




