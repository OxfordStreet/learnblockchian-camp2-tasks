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

    // keccak256("ERC777TokensRecipient") 哈希加密之后的结果就是下一行的十六进制数；ERC777.sol中有类似的赋值声明：
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    // IERC1820Registry 是一个接口，这里将其实例化；
    IERC1820Registry private erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    constructor(address _token) {
        token = _token;
        // erc1820.setInterfaceImplementer(addres(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this)); // 好想是全局搜索注册表，没看太明白；setInterfaceImplementer 也在IERC1820Registry.sol 中定义。
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