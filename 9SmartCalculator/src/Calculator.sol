// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import  "src/SmartCalculator.sol";

contract Calculator{
    address public owner;
    address public smartCalculatorAddress;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this action");
         _; 
    }
    
    function calculatePower(uint256 base, uint256 exponent)public view returns(uint256){

    SmartCalculator scientificCalc = SmartCalculator(smartCalculatorAddress);

    //external call 
    uint256 result = scientificCalc.power(base, exponent);

    return result;

}   
}