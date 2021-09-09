const { expect } = require("chai");
const { ethers } = require("hardhat");
// const assert = require("truffle-assertions")

describe("School", async function () {
  let School, school, students, signer1, signer2, signer3;
  const schoolName = "Astral Projection High School";
  const schoolAddress = "Space-Time Continuum, Area 51";
  before(async function () {
    [signer1, signer2, signer3] = await ethers.getSigners();
    students = {
      new: {
        name: "Kakashi Hatake",
        age: 21,
        address: signer2.address
      },
      update: {
        index: 0,
        name: "Uchiha Itachi",
        age: 23,
        address: signer3.address
      },
    }
    School = await ethers.getContractFactory("School");
    school = await School.connect(signer1).deploy(schoolName, schoolAddress);
    await school.deployed();
  });

  it("Should return the correct name and address of school", async function () {
    expect(await school.name()).to.equal(schoolName);
    expect(await school.schoolAddress()).to.equal(schoolAddress);
  });

  it("Should create a new student correctly", async function () {
    const tx = await (await school.connect(signer1).createStudent(
      students.new.name,
      students.new.age,
      students.new.address
    )).wait();
    const eventArgs = tx.events[0].args;
    // console.log(eventArgs);
    expect(eventArgs[1]).to.equal(students.new.name);
    expect(eventArgs[2].toNumber()).to.equal(students.new.age);
    expect(eventArgs[3].toString()).to.equal(students.new.address);
  });

  it("Should update a student's information correctly", async function () {
    const tx = await (await school.connect(signer1).updateStudentInfo(
      students.update.index,
      students.update.name,
      students.update.age,
      students.update.address
    )).wait();
    const eventArgs = tx.events[0].args;
    // console.log(eventArgs);
    expect(eventArgs[1]).to.equal(students.update.name);
    expect(eventArgs[2].toNumber()).to.equal(students.update.age);
    expect(eventArgs[3].toString()).to.equal(students.update.address);
  });

  it("Should return a student's info correctly", async function() {
    const studentId = 0;
    const studentInfo = await school.connect(signer2).viewStudentInfo(studentId);
    console.log("student info:", studentInfo)
    expect(studentInfo[0]).to.equal(students.update.name);
    expect(studentInfo[1]).to.equal(students.update.age);
    expect(studentInfo[2]).to.equal(students.update.address);
  });

  it("Should revert when not admin", async function() {
    const revertMsg = "School: only admin";
    expect(school.connect(signer2).createStudent(
      "Revert Guy", 10, signer3.address
    )).to.revertedWith(revertMsg);
  });

  it("Should revert when creating a student with null details", async function() {
    expect(school.connect(signer1).createStudent(
      "Revert Guy 1", 0, signer3.address
    )).to.revertedWith("School: invalid age");

    expect(school.connect(signer1).createStudent(
      "", 50, signer3.address
    )).to.revertedWith("School: name is required");

    expect(school.connect(signer1).createStudent(
      "Revert Guy 2", 30, ethers.constants.AddressZero
    )).to.revertedWith("School: zero address is unaccepted");
  });
});