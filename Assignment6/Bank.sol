//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
  address internal admin;
  address internal allowedCaller; // contract with setter functions
  string internal bankName;
  string internal bankAddress;
  mapping(address => Customer) internal customersMap;
  mapping(address => mapping(address => bool)) internal approvals;
  uint256 internal customerCounter;
  Customer[] internal customers;

  event NewCustomer(address customer);
  event ApprovedCustomer(address indexed approver, address indexed customer);
  event DisapprovedCustomer(address indexed approver, address indexed customer);
  event NewBankName(string oldName, string newName);
  event NewBankAddress(string oldAddress, string newAddress);
  event NewAdmin(address oldAdmin, address newAdmin);

  modifier onlyAdmin {
    require(msg.sender == admin, "Bank: Only admin");
    _;
  }
  
  modifier canUpdateState {
      require(msg.sender == admin || msg.sender == allowedCaller, "Unauthorized to change state");
      _;
  }

  modifier isApproved(address _customerToView) {
    require(approvals[_customerToView][msg.sender], "Bank: You are not approved");
    _;
  }
  constructor(string memory _bankName, string memory _bankAddress) {
    admin = msg.sender;
    bankName = _bankName;
    bankAddress = _bankAddress;
  }

  struct Customer {
    string name;
    string gender;
    uint8 age;
    uint248 registeredAt;
    address addr;
  }
  
  function permitCaller(address _caller) public onlyAdmin {
      require(_caller != address(0), "Bank: null address");
      allowedCaller = _caller;
  }

  function register(
    string memory _name,
    string memory _gender,
    uint8 _age
  ) public {
    Customer memory cus = customersMap[msg.sender];
    cus.addr = msg.sender;
    cus.name = _name;
    cus.gender = _gender;
    cus.age = _age;
    cus.registeredAt = uint248(block.timestamp);
    customersMap[msg.sender] = cus;
    customers.push(cus);
    customerCounter++;
    emit NewCustomer(msg.sender);
  }

  function approve(address _viewer) public {
    require(_viewer != address(0), "Bank: null address");
    require(!approvals[msg.sender][_viewer], "Bank: Viewer is already approved");
    approvals[msg.sender][_viewer] = true;
    emit ApprovedCustomer(msg.sender, _viewer);
  }
  function disapprove(address _viewer) public {
    require(_viewer != address(0), "Bank: null address");
    require(approvals[msg.sender][_viewer], "Bank: Viewer is not approved");
    approvals[msg.sender][_viewer] = false;
    emit DisapprovedCustomer(msg.sender, _viewer);
  }

  function customerIdentifier(address _customer) external view returns(bytes32) {
    Customer memory cust = customersMap[_customer];
    return keccak256(abi.encodePacked(cust.name, cust.registeredAt));
  }

  function viewCustomerDetails(address _customer) public view returns(Customer memory) {
    require(msg.sender == admin || approvals[_customer][msg.sender], "Bank: You are not approved");
    Customer memory cust = customersMap[_customer];
    return cust;
  }

  function getBankName() external view returns(string memory) {
    return bankName;
  }

  function getBankAddress() external view returns(string memory) {
    return bankAddress;
  }

  function getCustomers() external view returns(Customer[] memory) {
    return customers;
  }

  function changeBankName(string memory _newName) external canUpdateState {
    string memory _oldName = bankName;
    bankName = _newName;
    emit NewBankName(_oldName, _newName);
  }
  function changeBankAddress(string memory _newAddress) external canUpdateState  {
    string memory _oldAddress = bankAddress;
    bankAddress = _newAddress;
    emit NewBankAddress(_oldAddress, _newAddress);
  }

  function changeAdmin(address _newAdmin) external onlyAdmin {
    admin = _newAdmin;
    emit NewAdmin(msg.sender, _newAdmin);
  }
}