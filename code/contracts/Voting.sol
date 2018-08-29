pragma solidity ^0.4.22;

contract Voting {
  address private owner;

  struct Candidate{
    string name;
    uint8 voteCount;
  }

  Candidate[] private candidateList;

  struct Voter{
    address voterAddress;
    bool right;
  }

  mapping (uint => Voter) private voterList;
  uint8 private voterCount;

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

  function addVoter (address _voter) public {
    voterList[voterCount] = Voter(_voter, true);
    voterCount++;
  }

  function getVoter(uint8 _id) public view returns(address, bool){
    return (voterList[_id].voterAddress, voterList[_id].right);
  }

  function getVoterCount() public view returns (uint8){
    return voterCount;
  }

  function vote(uint8 _id) public {
    require( _id >= 0 && _id < candidateList.length);
    candidateList[_id].voteCount++;
  }
}
