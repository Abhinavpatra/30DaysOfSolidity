//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 Consider the AdminOnly smart contract. A new owner is assigned using the transferOwnership function, but the original deployer of the contract, let's call them "Old Admin," still holds a withdrawal allowance that was approved before the ownership transfer. The new owner, "New Admin," wants to ensure that only they, and no one else, can manage the contract's entire treasury. Create a scenario where the Old Admin attempts to exploit their pre-existing allowance and successfully withdraws funds, even after ownership has been transferred. Explain what vulnerability in the contract's logic allows this to happen and propose a specific, minimal change to the code that would prevent this exploit without changing the core functionality of a user withdrawing an approved allowance.

 */

contract AdminOnly{
    address public  owner;
    address[] owners;
    uint totalAmount;
    mapping(address => uint) withdrawlAllowance;
    modifier onlyOwner(){
        require(owner == msg.sender,"Only the owner can call this function");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        uint ownerAmount = withdrawlAllowance[owner] ;
        withdrawlAllowance[_newOwner] = ownerAmount;
        withdrawlAllowance[owner] = 0;
        owner = _newOwner;
    }

    function addTreasure(uint256 _amount) public onlyOwner {
        totalAmount += _amount;
    }
    
    function approveWithdrawl(address _recepient, uint256 _amount) public onlyOwner{
        require(_amount <= totalAmount, "Not enough treasure available");
        withdrawlAllowance[_recepient] = _amount;
    }

    function withdrawTreasure(uint256 _amount) public {
        
        uint256 allowance = withdrawlAllowance[msg.sender];
        require(allowance >= _amount,"You are not allowed to take this much");
        require(_amount <= totalAmount, "Not enough money in the bank");
        totalAmount -=_amount;
        withdrawlAllowance[msg.sender] -= _amount;        
    }

    function getTreasureDetails() public view onlyOwner returns (uint256) {
        return totalAmount;
    }
}

