
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Bank {
    uint256 TotalBalance;
    mapping(address => uint256) Accounts;

    function ShowTotalBalance() public view returns(uint256) {
        return TotalBalance;
    }

    function ShowBalance(address UserAddress) public view returns(uint256) {
        return Accounts[UserAddress];
    }
}
