// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TipJar{
    struct Currency {
        uint rate;// how many WEI equals to 1 of this currency
        bool exists;
    }
    address public owner;
    uint totalTip;
// how many WEI equals to 1 of this currency
    mapping(string => Currency) public currencyRateAndCheck;
    
// calculates total number of people who contributed    
    uint totalContributions;

// stores total tips per currency
    mapping(string => uint) totalTipsPerCurrency;

// all the currency strings
    string[] public currencies;

    modifier onlyOwner{
        require(owner == msg.sender, "Only owner is allowed, and you are not the Owner.");
        _;
    }

    constructor(){
        owner = msg.sender;
        addCurrency("USD", 2 *10**14);//1 US Dollar=0.0002396 Ethereum 1 ETH = 10^18 Wei
        addCurrency("INR", 2 *10**12);//1 INR =  0.00000270 Ethereum 1 ETH = 10^18 Wei
        addCurrency("ETH", 10**18);// 1 ETH = 10^18 WEI
    }
    
    function transferOwnership( address _newOwner ) public onlyOwner() {
        require(_newOwner != address(0),"Not allowed to set it to 0 address");
        require(owner != _newOwner, "New owner cant be the same as previous one");

        owner = _newOwner;
    }
    

    function addCurrency(string memory _newCurrencyName, uint rateForWei) public onlyOwner() {
        //checks that rate is apt, and that currencyRateAndCheck mapping does not have it
        // how many WEI equals to 1 of this currency
        require(rateForWei > 0, "The rate must be more than 0 ");
        require(!currencyRateAndCheck[_newCurrencyName].exists, "Only Allowed to set and add new Currencies");
        
        currencyRateAndCheck[_newCurrencyName] = Currency(rateForWei, true);
        currencies.push(_newCurrencyName);
    }

    function convertToEth(uint _amount, string memory _currencyCode) public view returns(uint) {
        require(currencyRateAndCheck[_currencyCode].exists,"This currency code does not exist and can't be converted");
        uint value = _amount * currencyRateAndCheck[_currencyCode].rate;
        return value;
        
    }

    function sendTip(string memory _currencyCode, uint _tip) public {
// add to total tips, add to totalTips of that currency, 
        Currency memory _currency = currencyRateAndCheck[_currencyCode];
        totalTipsPerCurrency[_currencyCode] += _tip;
        totalTip += _currency.rate * _tip;
        totalContributions++;

    }
    function sendEth() external payable{
        totalTipsPerCurrency["ETH"] += msg.value;
        totalTip +=msg.value;
        totalContributions++;
    }


    function withdrawTips() public onlyOwner(){
        address payable _to = payable(owner);
        _to.transfer(address(this).balance);

    }

    function currenciesAvailable() public view returns(string[] memory) {
        return currencies;
        
    }

    function getBalance() public view onlyOwner()  returns(uint){
        return totalTip;
    }

    function getConversionRate(string memory _currencyCode) public view returns(uint){
        return currencyRateAndCheck[_currencyCode].rate;
        
    }

    function changeConversionRate(string memory _currencyCode, uint _newRate) public onlyOwner() {
        currencyRateAndCheck[_currencyCode].rate = _newRate;
    }
    
}

