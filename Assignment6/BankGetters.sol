//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IBank.sol";
interface IBankGetters {
  function getBankName() external returns(string memory);
  function getBankAddress() external returns(string memory);
}
contract BankGetters {
  IBank bank;
  constructor(address _bankAddr) {
    bank = IBank(_bankAddr);
  }
  function getBankName() public view returns(string memory) {
    return bank.getBankName();
  }
  function getBankAddress() public view returns(string memory) {
    return bank.getBankAddress();
  }
}