var Voting = artifacts.require("Voting");

module.exports = function(deployer) { 
  // Use deployer to state migration tasks. 
  deployer.deploy(Voting); 
};
