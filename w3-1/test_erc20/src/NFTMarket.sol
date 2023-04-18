pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarket is IERC721Receiver{
    mapping(uint => uint) public tokenIdPrice; // tokenId <=> amount, tokenId和其价格的对应；
    address public immutable token;
    address public immutable nftToken;

    constructor(address _token, address _nftToken) {
        token = _token;
        nftToken = _nftToken;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // 上架NTF: 其实就是将用户使用ERC721生成的NFT转给本market合约
    // approve(address to, uint256 tokenId) 上架之前先授权，和ERC20代币deposit到Bank合约中的操作很像：都需要提前授权
    function list(uint tokenId, uint amount) public {
        IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenId, ""); // 使用safeTransferFrom给合约转帐，则此合约必须实现onERC721Received
        tokenIdPrice[tokenId] = amount; // 对比Bank中：deposited[user] += amount; 这里根据tokneID给NFT定价；
    }

    // 购买NFT
    function buy(uint tokenId, uint amount) external {
        require(amount >= tokenIdPrice[tokenId], "low prive"); // 判断出价不小于挂单价格
        require(IERC721(nftToken).ownerOf(tokenId) == address(this), "already selled"); // 判断要购买的NFT所有权仍属于本合约

        IERC20(token).transferFrom(msg.sender, address(this), tokenIdPrice[tokenId]); // 代币转给本合约
        IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);           // nft转给购买者msg.sender
    }


}