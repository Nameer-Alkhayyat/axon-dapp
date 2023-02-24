// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";



contract CarbonToken is ERC20, ERC721Holder{

    IERC721 public nft;

    uint256 public stakedTotal;
    uint256 public stakingStartTime;
    bool initRewards;



    mapping(uint256 => address) public tokenOwnerOf;
    mapping(uint256 => bool) public isStaked;

    address public owner;
    uint256 private _cap;
    uint256 public CurrentSupply = 0;



    constructor(address _nft) ERC20("AxonCarbonToken", "ACT"){
        owner = msg.sender;
        nft = IERC721(_nft);
    }

    modifier _onlyOwner(){
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function stake(uint256 tokenId) external {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwnerOf[tokenId] = msg.sender;
        isStaked[tokenId] = true;

    }

    // function calculateRewards(uint256 tokenId) public view returns(uint256){
    //     require(isStaked[tokenId], "This NFT was never staked");
    //     return 200;
    // }

    function unstake (uint256 tokenId) external {
        require(tokenOwnerOf[tokenId] == msg.sender, "You are not the owner of this nft");
        issueCarbonToken(msg.sender, 200);
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        delete tokenOwnerOf[tokenId];
        delete isStaked[tokenId];
    }








    function updateMaxSupply(uint256 cap_) public _onlyOwner {
        require(cap_ > 0, "ERC20Capped: cap is 0");
        _cap = cap_;
        CurrentSupply = cap_;

    }
    function updateCurrentSupply(uint256 amount) private  {
        CurrentSupply -= amount;
    }


    function issueCarbonToken(address _receiver, uint256 _amount) public {
        require(_cap > 0, "Denied: Waiting for the Oracle to update the MaxSupply!");
        require(ERC20.totalSupply() + _amount <= _cap, "ERC20Capped: cap exceeded");
        _mint(_receiver, _amount);
        updateCurrentSupply(_amount);
        
    }


}
