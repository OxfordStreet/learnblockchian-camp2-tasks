//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract MyERC20Callback is ERC20 {
    using Address for address;

    constructor() ERC20("MyERC20", "MyERC20") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    // 自定义函数以完成回调
    function transferWithCallback(address recipient, uint256 amount) external returns (bool) { // 这样通过一个操作就可以完成存款并记录，而ERC20 要了两步操作（先授权，再转账）。
        _transfer(msg.sender, recipient, amount);
        // 判断目标地址是否是合约，如果是合约就调用tokensReceived()
        if (recipient.isContract()) {
            bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount); // 假如说给Bank转账，就会检查Bank合约中有没有tokensReceived函数，如果有的话就会调用此函数。
            require(rv, "No tokensReceived");
        }

        return true;
    }


}