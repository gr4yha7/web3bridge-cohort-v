// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assignment4 {
  function crucial1(address a, address b, address c) public pure returns(bytes32 crucial1Hash) {
    bytes32 tempHash = keccak256(abi.encodePacked(a, b));
    crucial1Hash = keccak256(abi.encodePacked(tempHash, c));
  }
    
  function crucial2(uint _num, bytes32 _value) public pure returns(bytes32 finalHash) {
    address _first = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address _second = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address _third = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    bytes32 crucial1Hash = crucial1(_first, _second, _third);
    
    bytes32 numHash = keccak256(abi.encodePacked(_num));
    bytes32 valueHash = keccak256(abi.encodePacked(uint(_value)));
    finalHash = keccak256(abi.encodePacked(numHash, valueHash, crucial1Hash));
  }
}