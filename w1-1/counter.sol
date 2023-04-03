// // SPDX-License-Identifier: MIT
pragma solidity >=0.8.16 <0.9.0;

contract Counter {
    uint public counter;
    constructor() {
        counter = 0;
    }
    modifier onlyDeployer() {
        require(msg.sender == owner, "Only the contract depoyer can perform this action");
        _;
    }
    function count() public onlyDeployer {
        counter = counter + 1;
    }
    function add(uint x) public {
        counter = counter + x;
    }
}