// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assignment5 {
  mapping(address => uint) functionCallCounts;
  mapping(address => bytes32) lastCalledFunctionHash;
  
  function one() public returns(bool success) {
    functionCallCounts[msg.sender]++;
    lastCalledFunctionHash[msg.sender] = keccak256(abi.encodeWithSignature("one()"));
    success = true;
  }
  
  function two() public returns(bool success) {
    functionCallCounts[msg.sender]++;
    lastCalledFunctionHash[msg.sender] = keccak256(abi.encodeWithSignature("two()"));
    success = true;
  }
  
  function three() public returns(bool success) {
    functionCallCounts[msg.sender]++;
    lastCalledFunctionHash[msg.sender] = keccak256(abi.encodeWithSignature("three()"));
    success = !false;
  }
}