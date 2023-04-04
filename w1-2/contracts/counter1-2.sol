// // SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Counter {
    uint public counter;
    address public owner;
    constructor() {
        counter = 0;
        owner = msg.sender;
    }
    modifier onlyDeployer() {
        require(msg.sender == owner, "Only the contract depoyer can perform this action");
        _;
    }
    function count() public onlyDeployer {
        ++counter;
    }
    function add(uint x) public {
        counter = counter + x;
    }
}