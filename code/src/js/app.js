App = {
  web3Provider: null,
  contracts: {},

  init: function() {

    return App.initWeb3();
  },
  //접속할 이더리움의 노드를 설정하고 해당 노드의 첫 번째 어카운트 정보를 가져옵니다.
  initWeb3: function() {
    App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');  
    web3 = new Web3(App.web3Provider);
    App.account = web3.eth.accounts[0];
    return App.initContract();
  },

  initContract: function(){
    $.getJSON('Voting.json', function(voting){
      App.contracts.Voting = TruffleContract(voting); 
      App.contracts.Voting.setProvider(App.web3Provider);  
      return App.render();
    });
  },

  render: function(){
    var loader = $('.loader');
    var contents = $('.contents');
    var votingInstance;

    loader.show();
    contents.hide();

    App.contracts.Voting.deployed().then(function(instance){
      votingInstance = instance;
      votingInstance.getOwner.call().then(function(owner){
        contents.html("Contract Owner is: " + owner);
      });
    }).then(function(){
      loader.hide();
      contents.show();
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
