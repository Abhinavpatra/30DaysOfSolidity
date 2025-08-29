// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AuctionHouse {
    address public owner;
    string public item;
    mapping(address => uint) public bids;
    uint public auctionStartTime;
    uint public auctionEndTime;
    uint private highestBid;

    address[] public bidders;
    address private highestBidder;

    constructor(uint _totalTimeinSeconds, string memory _item) {
        item = _item;
        owner = msg.sender;
        highestBidder = address(0);

        auctionStartTime = block.timestamp;
        auctionEndTime = auctionStartTime + _totalTimeinSeconds;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only Owner can call this");
        _;
    }

    function bid() public payable {
        require(!isAuctionOver(), "The auction is over");
        require(msg.value > 0, "Bid amount must be positive");
        require(
            bids[msg.sender] + msg.value > highestBid,
            "New cumulative bid must be higher than the current highest bid"
        );

        // track new bidder
        if (bids[msg.sender] == 0) {
            bidders.push(msg.sender);
        }

        bids[msg.sender] += msg.value;

        if (bids[msg.sender] > highestBid) {
            highestBid = bids[msg.sender];
            highestBidder = msg.sender;
        }
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    // VIEWING FUNCTIONS
    function getWinner() public view returns (address) {
        return highestBidder;
    }

    function getHighestBid() public view returns (uint) {
        return highestBid;
    }

    function getAllBidders() external view returns (address[] memory) {
        return bidders;
    }

    function isAuctionOver() public view returns (bool) {
        return (block.timestamp > auctionEndTime);
    }

    // OWNER CLAIMS ONLY HIGHEST BID
    function claimFunds() public onlyOwner {
        require(isAuctionOver(), "Auction has not ended");
        require(highestBid > 0, "No funds to claim");

        uint amount = highestBid;
        highestBid = 0; // reset before transfer
        bids[highestBidder] = 0;

        payable(owner).transfer(amount);
    }

    // LOSERS WITHDRAW THEIR FUNDS
    function withdraw() external {
        require(isAuctionOver(), "Auction not yet ended");
        require(msg.sender != highestBidder, "Winner cannot withdraw");

        uint amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0; // effects before interaction
        payable(msg.sender).transfer(amount);
    }
}
