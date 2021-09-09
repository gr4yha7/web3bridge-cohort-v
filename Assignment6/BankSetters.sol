//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IBank.sol";
interface IBankSetters {
  function setBankName(string memory _newName) external;
  function setBankAddress(string memory _newAddress) external;
  function setNewAdmin(address _newAdmin) external;
}
contract BankSetters {
  IBank bank;
  constructor(address _bankAddr) {
    bank = IBank(_bankAddr);
  }
  function setBankName(string memory _newName) public {
    bank.changeBankName(_newName);
  }
  function setBankAddress(string memory _newAddress) public  {
    bank.changeBankAddress(_newAddress);
  }

  function setNewAdmin(address _newAdmin) public {
    bank.changeAdmin(_newAdmin);
  }
}