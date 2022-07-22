// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Bank {
    event Requested_TotalBalance(address _by);
    event Requested_UserBalance(address _by);
    event MoneyDeposited(address _by, uint256 Money);
    event MoneyWithdrawn(address _by, uint256 Money);
    event MoneyTransferred(address _by, address _to, uint256 Money);

    uint256 TotalBalance = 0;
    mapping(address => uint256) MoneyInAccount;
    mapping(address => uint256) AccountHistory;
    address immutable public OWNER;

    constructor() {
        OWNER = msg.sender;
    }

    function ShowTotalBalance() public returns(uint256) {
        emit Requested_TotalBalance(msg.sender);
        return TotalBalance;
    }

    function ShowBalance() public returns(uint256) {
        uint256 simpleInterest = CalcSimpleInterest(msg.sender);
        emit Requested_UserBalance(msg.sender);
        return (MoneyInAccount[msg.sender] + simpleInterest);
    }

    function CalcSimpleInterest(address UserAddress) internal view returns(uint256){
        uint256 TimeDifference = block.timestamp - AccountHistory[UserAddress];
        uint256 SimpleInterest = ( MoneyInAccount[UserAddress]* 7 * TimeDifference ) / (100*3600*24*365);
        return SimpleInterest;
    }

    // function ShowTime() public view returns(uint256) {
    //     return AccountHistory[msg.sender];
    // }

    function AddBalance() public payable{
        if(AccountHistory[msg.sender] != 0){
            MoneyInAccount[msg.sender] += CalcSimpleInterest(msg.sender);
        }
        AccountHistory[msg.sender]=block.timestamp;
        TotalBalance+=msg.value;
        MoneyInAccount[msg.sender]+=(msg.value);
        emit MoneyDeposited(msg.sender,msg.value);
    }

    function Withdraw(uint256 ethAmount) public {
        uint256 simpleInterest = CalcSimpleInterest(msg.sender);
        require( ( MoneyInAccount[msg.sender]+simpleInterest ) >= ethAmount , "Not enough money in account" );
        MoneyInAccount[msg.sender]+=simpleInterest;
        AccountHistory[msg.sender]=block.timestamp;
        MoneyInAccount[msg.sender]-=(ethAmount);
        TotalBalance-=ethAmount;
        payable(msg.sender).transfer(ethAmount);
        emit MoneyWithdrawn(msg.sender, ethAmount);
    }

    function Transfer(address _to, uint256 ethAmount) public {
        uint256 simpleInterest = CalcSimpleInterest(msg.sender);
        require( ( MoneyInAccount[msg.sender]+simpleInterest ) >= ethAmount , "Not enough money in account" );
        MoneyInAccount[msg.sender]+=simpleInterest;
        AccountHistory[msg.sender]=block.timestamp;
        MoneyInAccount[msg.sender]-=(ethAmount);
        TotalBalance-=ethAmount;
        payable(_to).transfer(ethAmount);
        emit MoneyTransferred(msg.sender,_to,ethAmount);
    }
}
