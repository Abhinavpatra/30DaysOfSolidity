// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SmartCalculator} from "../src/SmartCalculator.sol";

contract CounterTest is Test {
    SmartCalculator public counter;
// just put this in every test
    receive() external payable {}

    function setUp() public {
        counter = new SmartCalculator();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
