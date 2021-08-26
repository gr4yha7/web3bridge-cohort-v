
class Bank {
  admin = '';
  bankAddress = '';
  bankName = '';
  customers = new Map();
  approvals = new Map();

  isAdmin(addr) {
    return this.admin === addr;
  }

  isApproved(addr) {
    return this.approvals.get(addr)
  }
}