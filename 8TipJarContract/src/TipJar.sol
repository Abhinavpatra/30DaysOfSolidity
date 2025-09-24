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
    mapping(bytes32 => Currency) public currencyRateAndCheck;
    
// calculates total number of people who contributed    
    uint totalContributions;

// stores total tips per currency
    mapping(bytes32 => uint) totalTipsPerCurrency;

// all the currency strings
    bytes32[] public currencies;

    modifier onlyOwner{
        require(owner == msg.sender, "Only owner is allowed. ");
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
    

    function addCurrency(bytes32  _newCurrencyName, uint rateForWei) public onlyOwner() {
        //checks that rate is apt, and that currencyRateAndCheck mapping does not have it
        // how many WEI equals to 1 of this currency
        require(rateForWei > 0, "The rate must be more than 0 ");
        require(!currencyRateAndCheck[_newCurrencyName].exists, "Only Allowed to set and add new Currencies");
        
        currencyRateAndCheck[_newCurrencyName] = Currency(rateForWei, true);
        currencies.push(_newCurrencyName);

    }

    function convertToWei(uint _amount, bytes32  _currencyCode ) public view returns(uint) {
        require(currencyRateAndCheck[_currencyCode].exists,"This currency code does not exist and can't be converted");
        uint valueInWei = _amount * currencyRateAndCheck[_currencyCode].rate;
        return valueInWei;
        
    }

    function handleTips(bytes32  _currencyCode, uint _tip) public payable {
        uint tipInWei = convertToWei(_tip, _currencyCode);
        require((msg.value) == tipInWei);
        require(tipInWei > 0, "Tip must be more than 0");
        require(currencyRateAndCheck[_currencyCode].exists,"This currency code does not exist and can't be converted");
// add to total tips, add to totalTips of that currency,

        totalTipsPerCurrency[_currencyCode] += _tip;
        totalTip += tipInWei;
        totalContributions++;

    }
    function sendEth() public payable{
        totalTipsPerCurrency["ETH"] += msg.value ;
        totalTip += msg.value ;
        totalContributions++;
    }


    function withdrawTips() public onlyOwner(){

       (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
        for(uint i=0; i<currencies.length; i++){
            totalTipsPerCurrency[currencies[i]] = 0;
        }
        totalTip = 0;
    }

    function currenciesAvailable() public view returns(bytes32 [] memory) {
        return currencies;
        
    }

    function getBalance() public view returns(uint){
        return totalTip;
    }

    function getConversionRate(bytes32 _currencyCode) public view returns(uint){
        return currencyRateAndCheck[_currencyCode].rate;
        
    }

    function changeConversionRate(bytes32  _currencyCode, uint _newRate) public onlyOwner() {
        require(_newRate > 0,"Rate must be positive");
        currencyRateAndCheck[_currencyCode].rate = _newRate;
    }
    receive() external payable {
        sendEth();
    }
    
}

