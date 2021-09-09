const { ethers } = require("hardhat");

async function main() {
  const name = "Astral Projection High School";
  const address = "Space-Time Continuum, Area 51";
  const [account1, account2, account3] = await ethers.getSigners();
  const School = await ethers.getContractFactory("contracts/School.sol:School");
  const school = await School.deploy(name, address);

  await school.connect(account1).deployed();
  console.log("School deployed to:", school.address);

  const createTx = await (await school.connect(account1).createStudent("Levi Jaegar", 24, account2.address)).wait();
  console.log("Create Student Tx:", createTx);

  const updateTx = await (await school.connect(account1).updateStudentInfo(0, "Takashi Sensei", 21, account3.address)).wait();
  console.log("Update Student Tx:", updateTx);

  const viewTx = await school.connect(account2).viewStudentInfo(0);
  console.log("Student Info:", viewTx);

  const viewAllTx = await school.connect(account3).viewAllStudents();
  console.log("All Students:", viewAllTx);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
