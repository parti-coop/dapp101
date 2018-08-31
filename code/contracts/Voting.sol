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

  event VotedEvent(uint8 _id, address _voter);

  function getOwner() public view returns (address){
    return owner;
  }

  function addCandidate (string name) public onlyOwner {
    candidateList.push(Candidate(name,0));
  }

  function getCandidate(uint8 _id) public view returns(string, uint8){
    return (candidateList[_id].name, candidateList[_id].voteCount);
  }

  function getCandidateListLength() public view returns (uint){
    return candidateList.length;
  }

  function addVoter (address _voter) public onlyOwner{
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
    require(validateVoter(msg.sender));
    candidateList[_id].voteCount++;
    changeright(msg.sender);
    emit VotedEvent(_id, msg.sender);
  }

  function validateVoter(address _sender) private view returns (bool){
    for(uint8 i = 0; i < voterCount; i++){
      if(voterList[i].voterAddress == _sender){
        return voterList[i].right;
      }
    }
    return false;
  }

  function changeright(address _sender) private {
    for(uint8 i = 0; i < voterCount; i++){
      if(voterList[i].voterAddress == _sender){
        voterList[i].right = false;
      }
    }
  }

  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }
}
