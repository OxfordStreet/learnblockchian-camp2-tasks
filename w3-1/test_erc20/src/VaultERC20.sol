// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC1820Registry.sol";

// this may be exist in ERC777
interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

contract Vault is tokenRecipient {
    mapping(address => uint) public deposited;
    address public immutable token;

    constructor(address _token) {
        token = _token;
    }

    // 编写 deposite 方法，实现 ERC20 存入 Vault，并记录每个用户存款金额(approve/transferFrom)
    function deposit(address user, uint amount) public {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer from error");
    }

    // 编写 withdraw 方法，提取用户自己的存款
    function withdraw() public {
        (bool success, ) = msg.sender.call{value:deposited[msg.sender]}(new bytes(0));
        require(success, 'ETH transfer failed');
        deposited[msg.sender] = 0;
    }
}