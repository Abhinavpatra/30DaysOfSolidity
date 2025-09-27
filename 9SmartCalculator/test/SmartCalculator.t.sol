// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {SmartCalculator} from "../src/SmartCalculator.sol";

contract CounterTest is Test {
    SmartCalculator public counter;
// just put this in every test
    receive() external payable {}

    function setUp() public {
        counter = new SmartCalculator();
        counter.setNumber(0);
    }
}
