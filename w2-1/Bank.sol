// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner; ////owner用作存储合约所有者地址
    mapping (address=>uint) public balanceOf; //用来存储储户账户地址和对应的存储金额

    constructor() {
        owner = msg.sender; // 在合约部署时将部署者设置为合约所有者
    }
    // 函数修饰器：限制函数功能只能由owner操作
    modifier onlyOwner() {
        require(owner == msg.sender, 'Only contract owner can operate');
        _;
    }
    // 接收函数类似于fallback函数，但它专门设计用于处理传入的以太币而无需数据调用。这不是合约必须具备的功能，但对于直接发送到合约的以太币进行处理时非常有用。
    // https://ethereum.stackexchange.com/questions/19380/external-vs-public-best-practices
    receive() payable external {
        balanceOf[msg.sender] += msg.value;
    }
    // 查询msg.sender账户余额
    function myDeposited() public view returns(uint) {
        return balanceOf[msg.sender];
    }
    /**
     * add.transfer()由于有gas的限制，几乎无法向合约转账，这时候可以使用call。
     * addr.call{value: 1 ether}(new bytes(0))   =  addr.transfer(1 ether)
     */ 
    function withdraw() public {
        (bool success,) = msg.sender.call{value:balanceOf[msg.sender]}(new bytes(0));
        require(success, 'ETH transfer failed');
        balanceOf[msg.sender] = 0;
    }
    // 合约部署者将合约中的所有余额提取到自己账户地址
    function withdrawAll() public onlyOwner{
        uint b = address(this).balance; // address(this).balance 可以直接通过这种方式获取对应当前合约的余额;
        payable(owner).transfer(b);
    }


}