// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
contract SaveMyName{
    mapping (address=>string) names;
    address owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender == owner,"Only the owner can call this function, you are not the owner");
        _;
    }
    function setNewName(string memory name) public{
        names[msg.sender]= name;
    }
    function getMyName()public view returns(string memory)  {
        return names[msg.sender];
    }
    function getSomeonesName(address user) onlyOwner() public view returns(string memory)  {
        return names[user];   
    }
    function getAllNames() onlyOwner() public view returns(mapping (address=>string)memory)  {
        return names;
    }
}