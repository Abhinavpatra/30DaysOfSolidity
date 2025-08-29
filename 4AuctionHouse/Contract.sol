// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * Your task is to develop a Solidity smart contract for a basic auction system. The contract should allow a single owner to create an auction for a specific item, accept bids from multiple participants, and determine the winner after the auction has concluded.
 */

contract AuctionHouse{
    address public owner;
    string public item;
    mapping(address => uint) bids;
    uint public auctionStartTime;
    uint public auctionEndTime;
    uint private highestBid;
    
    address[] public bidders;
    address private highestBidder;

    constructor(uint _totalTimeinSeconds, string memory _item){
        item = _item;
        owner = msg.sender;
        highestBidder = address(0);

        auctionStartTime = block.timestamp;
        auctionEndTime =  auctionStartTime + _totalTimeinSeconds;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "Only Owner can call this");
        _;
    }

// take the bid, and compare it with the last highest bid, and if higher, then update it.
// bid must be more than 0.
    function bid() public payable {
        require(!isAuctionOver(),"The auction is over");
        require(msg.value > 0,"Bid amount must be +ve");
        require(msg.value > bids[msg.sender], "New bid must be higher than your current bid.");
        
        // if a bid is made, then this is added, then their address is added as a bidder.
        if(bids[msg.sender] == 0){
            bidders.push(msg.sender);
        }

        bids[msg.sender] = msg.value;
        if(msg.value > highestBid){
            highestBid = msg.value;
            highestBidder = msg.sender;
        } 
    }

    function changeOwner(address newOwner) public onlyOwner() {
        owner = newOwner;
    }   

    // VIEWING FUNCTIONS
    function getWinner() public view returns(address) {
        return highestBidder;
    }

    function getHighestBid() public view returns(uint){
        return highestBid;
    }

    function getAllBidders() external view returns (address[] memory) {
        return bidders;
    }

    function isAuctionOver() public view returns(bool) {
        return (block.timestamp > auctionEndTime);
    }

// getting funds
    function claimFunds() public onlyOwner {
        require(isAuctionOver(), "Auction has not ended");
        require(highestBid > 0,"No funds to claim ");
        uint amount = highestBid;
        bids[highestBidder] = 0;
        highestBid = 0;
        payable(owner).transfer(amount);
    }

    function withdraw() external{
        require(isAuctionOver(), "Auction not yet ended");
        uint amount = bids[msg.sender];
        require(msg.sender != highestBidder, "Winner cannot withdraw");

        bids[msg.sender] = 0; // prevent reentrancy
        payable(msg.sender).transfer(amount);
    }
}