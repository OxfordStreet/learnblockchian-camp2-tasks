//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract MyERC20 is ERC20 {

    constructor() ERC20(unicode"今晚打老虎", "Camp2_task") {
        _mint(msg.sender, 100000 * 10 ** 18);
    }

}