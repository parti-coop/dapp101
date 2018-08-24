pragma solidity ^0.4.22;


contract Voting {
  address public owner;
  constructor() {
    owner = msg.sender;
  }
}
