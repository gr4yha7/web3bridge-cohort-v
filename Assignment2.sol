// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assignment2 {
  bytes32 public hash1;
  bytes32 public hash2;
  
  function firstHash(string memory var1, string memory var2) public {
    hash1 = keccak256(abi.encodePacked(var1, var2));
  }
  
  function secondHash(string memory var1, string memory var2) public {
    hash2 = keccak256(abi.encodePacked(var1, var2));
  }
  
  function output() public view returns(bytes32, bytes32) {
    return (hash1, hash2);
  }
}