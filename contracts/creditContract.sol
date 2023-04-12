

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



contract sharesToken is ERC20, ERC721Holder{

    IERCNFT public nft;
    bool initRewards = false;
    uint256 created_at;
    uint256 expire_at;
    IERCToken public sharesContract;



    uint256 private _cap;
    uint256 private _capProgress;
    uint256 public _currentSupply = 0;



    constructor() ERC20("AxonCarbonToken", "ACT"){
        // owner = msg.sender;
        // nft = IERC721(_nft);
    }





    function _initRewards() external {
        
    }

    function updateCurrentSupply(uint256 amount) external  {

        // if(_currentSupply > 0){
        //     // get the share holders address and shares
        //    address [] owners = sharesContract.getAllOwners;
        //    for(uint256 i = 0; i <owners.length; i++){
        //         uint256 balance = sharesContract.balanceOf(i);
        //     // burn the the current token supply based on each holder share 
        //         burnCredits(i, balance);

        //    }






        //     // fire event
        //     // set the current supply to the new amount
        //     // update the cap progress
        //     // mint the token
        // }


        _mint(address(this), amount);


    }

    function burnCredits(address _to, uint256 _amount) public {

        _transfer(address(this), _to, _amount);
        _burn(_to, _amount);
        
    }




    // function calculateRewards(uint256 tokenId) public view returns(uint256){
    //     require(isStaked[tokenId], "This NFT was never staked");
    //     return 200;
    // }



    // function updateMaxSupply(uint256 cap_) public _onlyOwner {
    //     require(cap_ > 0, "ERC20Capped: cap is 0");
    //     _cap = cap_;
    //     CurrentSupply = cap_;

    // }




    // function issueCarbonToken(address _receiver, uint256 _amount) public {
    //     require(_cap > 0, "Denied: Waiting for the Oracle to update the MaxSupply!");
    //     require(ERC20.totalSupply() + _amount <= _cap, "ERC20Capped: cap exceeded");
    //     _mint(_receiver, _amount);
    //     updateCurrentSupply(_amount);
        
    // }


}
