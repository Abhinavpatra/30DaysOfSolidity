// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * Your task is to develop a Solidity smart contract for a basic auction system. The contract should allow a single owner to create an auction for a specific item, accept bids from multiple participants, and determine the winner after the auction has concluded.
 * 
 */

contract AuctionHouse{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address newOwner) public onlyOwner() {
        owner = newOwner;
    }
    
    
}