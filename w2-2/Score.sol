// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 记录学习成绩
contract Score {
    address public owner;
    address public teacher; 
    mapping (address=>uint) public scoreOf;
    error NotTeacher();
    error OverRange();

    constructor() {
        owner = msg.sender; // 
    }

    modifier onlyTeacher(){
        if(msg.sender != teacher){
            revert NotTeacher();
        }
        _;
    }

    // 只有owner有权限指定某地址为老师,要提前部署Teacher合约，将地址传参给setTeacher
    function setTeacher(address t) external {
        if(owner == msg.sender){
            teacher = t;
        }
    }

    // 修改学生分数
    function modify(address student, uint grade) external onlyTeacher{
        if(grade > 100 || grade < 0) revert OverRange();
        scoreOf[student] = grade;
    }
}

interface IScore {
    function modify(address student, uint grade) external;
}

// 注意部署Teacher合约地址时需要传入Score合约地址作为gou
contract Teacher {
    IScore iscore; // 将接口看作一种类型，这里iscore是接口声明

    constructor(address s){ 
        iscore = IScore(s); // 通过给接口类型传入参数完成实例化
    }

    function modifyScoreByInterface(address _student, uint _grade) public {
        iscore.modify(_student, _grade);
    }
}


