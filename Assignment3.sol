// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assignment3 {
  uint [5][6][4] public street;
  // room, flat, house
  
  // number of houses in the street
  uint public houses;
  // number of flats per house in the street
  uint public flatsPerHouse;
  // number of rooms per flat in the street
  uint public roomsPerFlat;
  // total number of flats in the street
  uint public totalFlats;
  // total number of rooms in the street
  uint public totalRooms;
  // total number of occupants in the street
  uint public totalOccupants;
  
  constructor() {
    street = [[[1,2,4,3,2],[4,1,3,5,2],[6,2,1,3,2],[5,2,3,1,2],[1,2,3,4,5],[4,3,3,2,2]],
      [[1,2,3,4,2],[2,4,2,3,1],[1,1,4,3,3],[2,1,4,2,5],[2,4,2,4,1],[2,3,3,4,2]],[[3,2,2,1,2],[4,2,4,5,2],[1,2,3,2,3],[4,2,4,3,2],[1,2,1,1,2],[4,2,4,3,2]],
      [[4,2,3,5,2],[3,2,2,1,5],[4,4,3,2,1],[5,5,2,1,2],[3,3,2,4,1],[1,1,1,2,2]]];
    houses = street.length;
    flatsPerHouse = street[0].length;
    roomsPerFlat = street[0][0].length;
  }
  
  function calculateTotals() public {
    totalFlats = houses * flatsPerHouse;
    totalRooms = houses * flatsPerHouse * roomsPerFlat;
    // calculate total occupants in the street
    for (uint256 i; i < houses; i++) {
      for (uint256 j; j < flatsPerHouse; j++) {
        for (uint256 k; k < roomsPerFlat; k++) {
          totalOccupants += street[i][j][k];
        }
      }
    }
  }
}