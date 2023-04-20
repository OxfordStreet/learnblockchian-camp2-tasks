pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";

contract MyERC721 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721(unicode"今晚打老虎", "CAMP2TASK") {}

    //  tokenURI 可以直接传参数string 但是会比较大， 一般放到IPFS中

    // ipfs://QmT4YDZ2dgTSpfHwPndnSuvHrAXNvtDBKNDUwN8nuZiVHT
    function mint(address student, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(student, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}