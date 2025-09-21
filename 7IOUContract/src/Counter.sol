// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract IOUContract {
    address public owner;
    mapping (address => mapping(address=>uint)) public debts;// the first one is the one who owes money to the seocnd guy.
    // debtor -> creditor -> amount
    address[] public friends;
    mapping (address => bool)isAFriend;

    mapping(address => uint256) public balances;

    constructor(){
        owner = msg.sender;
        isAFriend[owner] = true;
        friends.push(msg.sender);
    } 

    modifier onlyOwner(){
        require(msg.sender == owner,"Can be called only by owner");
        _;
    }
    modifier onlyRegistered(){
        require(isAFriend[msg.sender],"only a registered Friend can call this function");
        _;
    }
    
    function addFriend(address _newFriend)public onlyOwner(){
        require(_newFriend != address(0), "Invalid address");
        require(!isAFriend[_newFriend], "Friend already registered");
        friends.push(_newFriend);
        isAFriend[_newFriend]= true;

    }

    function depositToWallet() public payable onlyRegistered(){
        require(msg.value > 0, "The money deposited must be more than 0.");
        balances[msg.sender]+= msg.value;
    }
    
    function recordDebt(address _debtor, uint256 _amount) public onlyRegistered() {
        require(isAFriend[_debtor], "Everyone must be a friend");
        debts[_debtor][msg.sender] += _amount;
    }

    function payFromWallet(address _creditor, uint256 _amount) public onlyRegistered() {
        require(_creditor != address(0), "Invalid address");
        require(isAFriend[_creditor], "Creditor not registered");
        require(_amount > 0, "Amount must be greater than 0");
        require(debts[msg.sender][_creditor] >= _amount, "The amount is more than what is owed");
        debts[msg.sender][_creditor] -=_amount;
        balances[_creditor] += _amount;
        balances[msg.sender] -= _amount;
    }

    function transferEther(address payable _to, uint256 _amount) public onlyRegistered(){
        // require(isAFriend[_to],"only friend"); modifer does this, it also by proxy takes care of _to being address(0)
        require(balances[msg.sender] >= _amount,"Insufficient balance, deposit more if you wish to transfer that much");
        balances[msg.sender] -= _amount;

        (bool success, ) = _to.call{value: _amount}("");

        require(success, "Transfer failed");
    }


    function withdraw( uint _amount) public onlyRegistered(){
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Failed to Withdraw");
    }
}

/**
 * The SimpleIOU contract is a basic smart contract on the Ethereum blockchain that functions as a simple system for managing IOU (I Owe You) debts and Ether balances among a group of registered friends. 

The contract allows users to:

    Deposit Ether into their own internal contract balance.

    Record debts owed to them by other registered friends.

    Pay off debts using their internal balance.

    Transfer Ether to other registered friends.

    Withdraw their Ether balance from the contract.

    Check their current balance.

Only the contract's owner can register new friends, and only registered friends can use the main functionalities of the contract. The contract uses mapping to track balances and debts, as well as an array (friendList) to keep a list of all registered participants.
 */