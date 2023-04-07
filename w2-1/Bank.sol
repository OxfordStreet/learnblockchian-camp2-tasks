// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;
    mapping (address=>uint) public balanceOf;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, 'Only contract owner can operate');
        _;
    }
    
    // https://ethereum.stackexchange.com/questions/19380/external-vs-public-best-practices
    receive() payable external {
        balanceOf[msg.sender] += msg.value;
    }

    function myDeposited() public view returns(uint) {
        return balanceOf[msg.sender];
    }
    
    function withdraw() public {
        (bool success,) = msg.sender.call({value:balanceOf[msg.sender]}(new bytes(0)));
        require(success, 'ETH transfer failed');
        balanceOf[msg.sender] = 0;
    }

    function withdrawAll() public onlyOwner{
        uint b = address(this).balance; // address(this).balance 可以直接通过这种方式获取对应当前合约的余额;
        payable(owner).transfer(b);
    }


}