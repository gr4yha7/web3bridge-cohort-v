//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IBank {
  // struct Customer {
  //   string name;
  //   string gender;
  //   uint8 age;
  //   uint248 registeredAt;
  //   address addr;
  // }
  function permitCaller(address _caller) external;
  function register(string memory _name, string memory _gender, uint8 _age) external;
  function approve(address _viewer) external;
  function disapprove(address _viewer) external;
  function customerIdentifier(address _customer) external returns(bytes32);
  // function viewCustomerDetails(address _customer) external returns(Customer memory);
  function getBankName() external view returns(string memory);
  function getBankAddress() external view returns(string memory);
  // function getCustomers() external view returns(Customer[] memory);
  function changeBankName(string memory _newName) external;
  function changeBankAddress(string memory _newAddress) external;
  function changeAdmin(address _newAdmin) external;
}