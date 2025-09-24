// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TipJar.sol";

contract TipJarTest is Test {
    TipJar jar;
    address owner;
    address user = address(1);
    //  this to allow the test contract to receive ETH
    receive() external payable {}

    function setUp() public {
        owner = address(this);
        jar = new TipJar();
    }

    function testOwnerIsCorrect() public view{
        assertEq(jar.owner(), owner);
    }

    function testAddCurrency() public {
        jar.addCurrency("GBP", 3 * 10**14);
        bytes32[] memory available = jar.currenciesAvailable();
        assertEq(available[available.length - 1], "GBP");
        assertEq(jar.getConversionRate("GBP"), 3 * 10**14);
    }

    function testHandleTipETH() public {
        uint tipAmount = 1 ether;
        vm.deal(address(this), tipAmount);  // Fund the test contract
        jar.handleTips{value: tipAmount}("ETH", 1);  // Change _tip to 1 (one ETH unit)
        assertEq(jar.getBalance(), tipAmount);
    }

    function testHandleTipUSD() public {
        uint usdTip = 10; // 10 USD
        uint expectedWei = usdTip * jar.getConversionRate("USD");
        vm.deal(user, expectedWei);
        vm.prank(user);
        jar.handleTips{value: expectedWei}("USD", usdTip);
        assertEq(jar.getBalance(), expectedWei);
    }

    function testWithdrawTips() public {
        uint tipAmount = 1 ether;
        vm.deal(address(this), tipAmount);  // Fund the test contract
        jar.sendEth{value: tipAmount}();
        uint balanceBefore = address(this).balance;
        jar.withdrawTips();
        uint balanceAfter = address(this).balance;
        assertEq(balanceAfter - balanceBefore, tipAmount);
        assertEq(jar.getBalance(), 0);
    }

    function testTransferOwnership() public {
        address newOwner = address(2);
        jar.transferOwnership(newOwner);
        assertEq(jar.owner(), newOwner);
    }
}
