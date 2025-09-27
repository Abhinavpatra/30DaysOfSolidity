// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SmartCalculator{
    function power(uint base, uint exponent) public pure returns (uint){
        if(exponent == 0) return 1;
        return base ** exponent;   
    }
    function squareRoot(int number) public pure returns (int) {
        require(number > 0, "The Number needs to be greater than 0");
        if(number <= 1) return number;
        
    }



}
