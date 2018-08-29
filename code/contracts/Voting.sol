pragma solidity ^0.4.22;

contract Voting {
  address private owner;

  struct Candidate{
    string name;
    uint8 voteCount;
  }

  Candidate[] private candidateList;

  constructor() public{
    owner = msg.sender;
  }

  function getOwner() public view returns (address){
    return owner;
  }

  function addCandidate (string name) public{
    candidateList.push(Candidate(name,0));
  }

  function getCandidate(uint8 _id) public view returns(string, uint8){
    return (candidateList[_id].name, candidateList[_id].voteCount);
  }

  function getCandidateListLength() public view returns (uint){
    return candidateList.length;
  }
}
