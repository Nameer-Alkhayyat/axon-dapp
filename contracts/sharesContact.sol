// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IERCNFT.sol";



contract sharesToken is ERC20, ERC721Holder{

    IERCNFT public nft;
    address public owner;
    uint256 public _totalSupply;
    uint256 remainingSupply;


    mapping(uint256 => address) public tokenOwnerOf;
    mapping(uint256 => bool) public isStaked;


    constructor() ERC20("AxonCarbonToken", "ACT"){
        owner = msg.sender;
        // nft = IERC721(_nft);
    }

    modifier _onlyOwner(){
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function stake(address _sender, uint256 tokenId) internal {

        nft.transferFrom(_sender, address(this), tokenId);
        tokenOwnerOf[tokenId] = msg.sender;
        isStaked[tokenId] = true;

    }

    function setMinterNFT(address _sender, address _nft, uint256 _tokenId) external{

        nft = IERCNFT(_nft);
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
        require(shares >= 10, "Shares: too small");
        require(remainingSupply > 0, "no more share to mint");
        _mint(msg.sender, shares);
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
    function getPrice() view public returns (uint256) {

       return  nft.getPrice();
        
    }


}




// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./NFT.sol";

// contract NFTShares is Ownable {
//     struct NftShare {
//         uint256 totalShares;
//         uint256 remainingShares;
//         uint256 pricePerShare;
//         address[] owners;
//         mapping(address => uint256) balances;
//     }

//     NftShare private _nftShare;
//     NFT private _nftContract;

//     event NftStaked(address indexed from, uint256 indexed tokenId, uint256 shares);
//     event SharesBought(address indexed from, uint256 indexed tokenId, uint256 shares);
//     event SharesSold(address indexed from, uint256 indexed tokenId, uint256 shares, uint256 totalPrice);

//     constructor(address nftContractAddress) {
//         _nftContract = NFT(nftContractAddress);
//     }

//     function stake(uint256 tokenId, uint256 shares, uint256 pricePerShare) public {
//         require(_nftShare.totalShares == 0, "NFTShares: only one NFT can be staked at a time");
//         require(_nftContract.ownerOf(tokenId) == _msgSender(), "NFTShares: must own token");
//         require(shares > 0, "NFTShares: must stake at least one share");

//         _nftShare.totalShares = shares;
//         _nftShare.remainingShares = shares;
//         _nftShare.pricePerShare = pricePerShare;
//         _nftShare.owners.push(_msgSender());

//         _mintShares(shares);

//         emit NftStaked(_msgSender(), tokenId, shares);
//     }

//     function buyShares(uint256 shares) public payable {
//         require(_nftShare.remainingShares >= shares, "NFTShares: not enough shares remaining");
//         require(msg.value == shares * _nftShare.pricePerShare, "NFTShares: invalid payment amount");

//         _transferShares(_msgSender(), shares);
//         _nftShare.remainingShares -= shares;

//         emit SharesBought(_msgSender(), _nftContract.tokenOfOwnerByIndex(owner(), 0), shares);
//     }

//     function sellShares(uint256 shares, uint256 pricePerShare) public {
//         require(_nftShare.balances[_msgSender()] >= shares, "NFTShares: not enough shares owned");

//         _nftShare.pricePerShare = pricePerShare;

//         _transferShares(address(this), shares);

//         emit SharesSold(_msgSender(), _nftContract.tokenOfOwnerByIndex(owner(), 0), shares, shares * pricePerShare);
//     }

//     function _mintShares(uint256 shares) private {
//         ERC20 sharesToken = new ERC20("NFTSharesToken", "NFTS");

//         for (uint256 i = 0; i < _nftShare.owners.length; i++) {
//             address owner = _nftShare.owners[i];
//             uint256 balance = (shares * _nftShare.balances[owner]) / _nftShare.totalShares;
//             sharesToken.transfer(owner, balance);
//             _nftShare.balances[owner] = balance;
//         }
//     }

//     function _transferShares(address to, uint256 shares) private {
//         ERC20 sharesToken = ERC20(address(this));
//         uint256 balance = sharesToken.balanceOf(_msgSender());
//         require(balance >= shares, "NFTShares: not enough shares owned");

//         sharesToken.transferFrom(_msgSender(), to, shares);

//         uint256 remainingBalance = sharesToken.balanceOf(_msgSender());
//         uint256 newBalance = _nftShare.totalShares - _nftShare.remainingShares;
//         _nftShare.balances[_msgSender()] = (newBalance * remainingBalance) / _nftShare.remainingShares;
//         _nftShare.balances[to] += shares;

//         if (_nftShare.balances[_msgSender()] == 0) {
//             for (uint256 i = 0; i < _nftShare.owners.length; i++) {
//                 if (_nftShare.owners[i] == _msgSender()) {
//                     _nftShare.owners[i] = _nftShare.owners[_nftShare.owners.length - 1];
//                     _nftShare.owners.pop();
//                     break;
//                 }
//             }
//         }

//         if (_nftShare.balances[to] == shares) {
//             _nftShare.owners.push(to);
//     }
// }

    
//     }