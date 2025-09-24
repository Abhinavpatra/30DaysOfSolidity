// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TipJar{
    struct Currency {
        uint rate;// how many WEI equals to 1 of this currency
        bool exists;
    }
    constructor(){
        owner = msg.sender;
        addCurrency("USD", 2 *10^14);//1 US Dollar=0.0002396 Ethereum 1 ETH = 10^18 Wei
        addCurrency("INR", 2 *10^12);//1 INR =  0.00000270 Ethereum 1 ETH = 10^18 Wei
    }
    address public owner;
    mapping(string => Currency) public currencyRateCheck;// how many WEI equals to 1 of this currency
    
    uint totalContributions;// calculates total number of people who contributed

    mapping(uint => Currency) tipsPerCurrency;// stores total tips
    string[] public currencies;// all the currency strings 

    modifier onlyOwner{
        require(owner == msg.sender, "Only owner is allowed, and you are not the Owner.");
        _;
    }

    function transferOwnership() public onlyOwner() {
        
    }
    

    function addCurrency(string memory _newCurrencyName, uint rateForWei) public onlyOwner() {
        //checks that rate is apt, and that currencyRateCheck mapping does not have it
        // how many WEI equals to 1 of this currency
        require(rateForWei > 0, "The rate must be more than 0 ");
        require(!currencyRateCheck[_newCurrencyName].exists, "Only Allowed to set and add new Currencies");
        
        currencyRateCheck[_newCurrencyName] = Currency(rateForWei, true);
        currencies.push(_newCurrencyName);
    }
    function converToEth(uint _amount, string memory _currencyCode) public {
        require(currencyRateCheck[_currencyCode].exists,"This currency code does not exist and can't be converted");

        
    }

    function sendTip(string memory _currencyCode, uint _tip) public{

    }

    function withdrawTips() public onlyOwner(){

    }

    function currenciesAvailable() public view returns(string[] memory) {
        
    }

    function getBalance() public view onlyOwner()  returns(uint){

    }

    function getConversionRate(string memory _currencyCode) public view{
        
    }
    function changeConversionRate(string memory _currencyCode) public onlyOwner() {
        
    }
}

