const ethers = require('ethers')

class Bank {
  admin = '';
  approvedSetter = '';
  bankAddress = '';
  bankName = '';
  customers = [];
  customersMap = new Map();
  approvals = new Map();
  
  constructor(_admin, _bankName, _bankAddress) {
    this.admin = _admin;
    this.bankName = _bankName;
    this.bankAddress = _bankAddress;
  }

  get getBankName() {
    return this.bankName;
  }

  get getBankAddress() {
    return this.bankAddress;
  }

  get getBankCustomers() {
    return this.customers;
  }

  changeBankName(_caller, _newName) {
    if (this.isAdmin(_caller) || this.isApprovedToChangeState(_caller)) {
      this.bankName = _newName;
    } else console.error("Action not permitted. Unauthorized caller");
  }

  changeBankAddress(_caller, _newAdmin) {
    if (this.isAdmin(_caller) || this.isApprovedToChangeState(_caller)) {
      this.bankAdmin = _newAdmin;
    } else console.error("Action not permitted. Unauthorized caller");
  }

  changeBankAdmin(_caller, _newAdmin) {
    if (this.isAdmin(_caller) || this.isApprovedToChangeState(_caller)) {
      this.admin = _newAdmin;
    } else console.error("Action not permitted. Unauthorized caller");
  }
  
  // function for checking that the function caller is the admin
  isAdmin(addr) {
    return this.admin === addr;
  }
  
  isApprovedToView(_approver, _viewer) {
    const approvedAddresses = this.approvals.get(_approver);
    const match = approvedAddresses.filter(x => x === _viewer);
    return match.length > 0;
  }
  
  isApprovedToChangeState(addr) {
    return this.approvedSetter === addr;
  }

  setApprovedSetter(_addr) {
    if (_addr !== '') {
      this.approvedSetter = _addr;
    }
  }
  
  register(_address, _name, _gender, _age) {
    let customer = {
      name: _name,
      gender: _gender,
      age: _age,
      registeredAt: Date.now(),
      address: _address
    }
    this.customersMap.set(address, customer);
    this.customers.push(customer);
  }

  approve(_approver, _viewer) {
    if (_approver === '' || _viewer === '') {
      console.error("Empty addresses are not allowed")
    }
    if (this.approvals.has(_approver)) {
      let previousApprov = this.approvals.get(_approver);
      let updatedApprov = [...previousApprov, _viewer]
      this.approvals.set(_approver, updatedApprov)
    } else {
      this.approvals.set(_approver, [_viewer]);
    }
  }

  disapprove(_approver, _viewer) {
    if (_approver === '' || _viewer === '') {
      console.error("Empty addresses are not allowed")
    }
    if (this.approvals.has(_approver)) {
      let approvals = this.approvals.get(_approver);
      let updatedApprov = approvals.filter(x => x !== _viewer);
      this.approvals.set(_approver, updatedApprov)
    } else {
      console.error("Approver does not exist");
    }
  }

  getCustomerIdentifier(_customerAddr) {
    const customer = this.customersMap.get(_customerAddr);
    if (customer) {
      const types = ['string', 'uint248'];
      const values = [customer.name, customer.registeredAt];
      return ethers.utils.solidityKeccak256(types, values);
    } else {
      console.error('Customer does not exist')
      return null;
    }
  }

  viewCustomerDetails(_caller, _customerAddr) {
    if (this.isAdmin(_caller) || this.isApprovedToView(_caller)) {
      return this.customersMap.get(_customerAddr);
    }
  }
}

function runSimulation() {
  const admin = '0xeeeeeeeeeeeeeeeeee';
  const name = 'Bankless Bank';
  const address = '4th Dimension, Wormhole';
  let bank = new Bank(admin, name, address);

  let approver = '0xaaaaaaaaaa';
  let viewer1 = '0xbbbbbbbbbb';
  let viewer2 = '0xcccccccccc';
  
  bank.approve(approver, viewer1);
  bank.approve(approver, viewer2);
  console.log(bank.approvals);
  bank.disapprove(approver, viewer1);
  console.log(bank.approvals);
  console.log("approved", bank.isApprovedToView(approver, viewer2));
  console.log("approved", bank.isApprovedToView(approver, viewer1));
}

runSimulation();