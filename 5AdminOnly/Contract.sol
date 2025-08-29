//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 Consider the AdminOnly smart contract. A new owner is assigned using the transferOwnership function, but the original deployer of the contract, let's call them "Old Admin," still holds a withdrawal allowance that was approved before the ownership transfer. The new owner, "New Admin," wants to ensure that only they, and no one else, can manage the contract's entire treasury. Create a scenario where the Old Admin attempts to exploit their pre-existing allowance and successfully withdraws funds, even after ownership has been transferred. Explain what vulnerability in the contract's logic allows this to happen and propose a specific, minimal change to the code that would prevent this exploit without changing the core functionality of a user withdrawing an approved allowance.

 */

contract AdminOnly{
    address public  owner;
    address[] owners;
    modifier onlyOwner(){
        require(owner == msg.sender,"Only the owner can call this function");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }
}