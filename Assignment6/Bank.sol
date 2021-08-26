//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBank {
  function register(
    string memory _name,
    string memory _gender,
    string memory _bvn,
    string memory _nationality,
    uint8 _age
  ) external;
  function approve(address _viewer) external;
  function customerIdentifier(address _customer) external returns(bytes32);
  // function viewCustomerDetails(address _customer) external returns(Customer memory);
}

contract Bank {
  address internal admin;
  string public bankName;
  string public bankAddress;
  mapping(address => Customer) public customers;
  mapping(address => mapping(address => bool)) public approvals;
  uint256 internal customerCounter;

  event NewCustomer(address customer);
  event ApprovedCustomer(address indexed approver, address indexed customer);
  event NewBankName(string indexed oldName, string indexed newName);
  event NewBankAddress(string indexed oldAddress, string indexed newAddress);

  modifier onlyAdmin {
    require(msg.sender == admin, "Bank: Only admin");
    _;
  }

  modifier isApproved(address _customerToView) {
    require(approvals[_customerToView][msg.sender], "Unapproved");
    _;
  }
  constructor() {
    admin = msg.sender;
  }

  struct Customer {
    string name;
    string gender;
    string bvn;
    string nationality;
    uint8 age;
    uint248 registeredAt;
  }

  function register(
    string memory _name,
    string memory _gender,
    string memory _bvn,
    string memory _nationality,
    uint8 _age
  ) public {
    Customer memory cus = customers[msg.sender];
    cus.name = _name;
    cus.gender = _gender;
    cus.bvn = _bvn;
    cus.nationality = _nationality;
    cus.age = _age;
    cus.registeredAt = uint248(block.timestamp);
    customers[msg.sender] = cus;
    customerCounter++;
    emit NewCustomer(msg.sender);
  }

  function approve(address _viewer) public {
    require(_viewer != address(0));
    require(!approvals[msg.sender][_viewer], "Already approved");
    approvals[msg.sender][_viewer] = true;
    emit ApprovedCustomer(msg.sender, _viewer);
  }

  function customerIdentifier(address _customer) external returns(bytes32) {
    Customer memory cust = customers[_customer];
    return keccak256(abi.encodePacked(cust.name, cust.registeredAt));
  }

  function viewCustomerDetails(address _customer) public view returns(Customer memory cust) {
    require(msg.sender == admin || approvals[_customer][msg.sender], "Unapproved");
    cust = customers[_customer];
  }

  function _changeBankName(string memory _newName) internal onlyAdmin {
    string memory _oldName = bankName;
    bankName = _newName;
    emit NewBankName(_oldName, _newName);
  }
  function _changeBankAddress(string memory _newAddress) internal onlyAdmin  {
    string memory _oldAddress = bankAddress;
    bankAddress = _newAddress;
    emit NewBankAddress(_oldAddress, _newAddress);
  }

  function _changeAdmin(address _newAdmin) internal onlyAdmin {
    admin = _newAdmin;
  }
}

contract BankGetters is Bank {
  function getBankName() public view returns(string memory) {
    return bankName;
  }
  function getBankAddress() public view returns(string memory) {
    return bankAddress;
  }
  function getCustomersCount() public view returns(uint256) {
    return customerCounter;
  }
}

contract BankSetters is Bank {
  function setBankName(string memory _newName) public onlyAdmin {
    string memory _oldName = bankName;
    bankName = _newName;
    emit NewBankName(_oldName, _newName);
  }
  function setBankAddress(string memory _newAddress) public onlyAdmin  {
    string memory _oldAddress = bankAddress;
    bankAddress = _newAddress;
    emit NewBankAddress(_oldAddress, _newAddress);
  }

  function setNewAdmin(address _newAdmin) public onlyAdmin {
    admin = _newAdmin;
  }
}