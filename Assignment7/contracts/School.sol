// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;
import "hardhat/console.sol";

contract School {
  string public name;
  string public schoolAddress;
  uint256 private id;
  address public admin;
  mapping(uint256 => Student) public students;
  Student[] public allStudents;

  struct Student {
    string name;
    uint256 age;
    address addr;
  }

  event NewStudent(uint256 studentId, string name, uint256 age, address addr);
  event UpdatedStudent(uint256 studentId, string newName, uint256 newAge, address newAddr);
  modifier onlyAdmin {
    require(msg.sender == admin, "School: only admin");
    _;
  }

  modifier checksOut(string memory _name, uint256 _age, address _addr) {
    require(bytes(_name).length > 0, "School: name is required");
    require(_age > 0, "School: invalid age");
    require(_addr != address(0), "School: zero address is unaccepted");
    _;
  }

  constructor(string memory _name, string memory _schoolAddress) {
    admin = msg.sender;
    name = _name;
    schoolAddress = _schoolAddress;
  }
  function viewStudentInfo(uint _studentId) public view returns(Student memory student) {
    student = students[_studentId];
  }
  function createStudent(string memory _name, uint256 _age, address _addr) public onlyAdmin checksOut(_name, _age, _addr) {
    console.log("Current id", id);
    Student storage student = students[id];
    student.name = _name;
    student.age = _age;
    student.addr = _addr;
    emit NewStudent(id, _name, _age, _addr);
    allStudents.push(student);
    id++;
  }

  function updateStudentInfo(uint _studentId, string memory _newName, uint256 _newAge, address _newAddr) public onlyAdmin checksOut(_newName, _newAge, _newAddr) {
    console.log("Passed id", _studentId);
    require(_studentId <= id, "School: student doesn't exist");
    Student storage student = students[_studentId];
    student.name = _newName;
    student.age = _newAge;
    student.addr = _newAddr;
    allStudents[_studentId] = student;
    emit UpdatedStudent(_studentId, _newName, _newAge, _newAddr);
  }

  function viewAllStudents() public view returns(Student[] memory) {
    return allStudents;
  }
}