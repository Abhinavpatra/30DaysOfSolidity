// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract IOUContract {
    
}

/**
 * The SimpleIOU contract is a basic smart contract on the Ethereum blockchain that functions as a simple system for managing IOU (I Owe You) debts and Ether balances among a group of registered friends. 🤝

The contract allows users to:

    Deposit Ether into their own internal contract balance.

    Record debts owed to them by other registered friends.

    Pay off debts using their internal balance.

    Transfer Ether to other registered friends.

    Withdraw their Ether balance from the contract.

    Check their current balance.

Only the contract's owner can register new friends, and only registered friends can use the main functionalities of the contract. The contract uses mapping to track balances and debts, as well as an array (friendList) to keep a list of all registered participants. 📝
 */