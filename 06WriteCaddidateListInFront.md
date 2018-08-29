# 후보자 리스트 Front-End에 출력하기

## index.html 수정
후보자 리스트를 출력한 테이블을 생성하고 컨트랙트 주소를 출력한 태그를 만듭니다.

```
<div class="container"> 
  <h1>Park's Voting</h1> 
  <div class="loader">Loading...</div> 
  <hr>
  <br> 
  <div class="contents">
    <div>
      <p class="owner"></p>
      <table class="table">
        <thead>
          <th>id</th>
          <th>NAME</th>
          <th>Votes Count</th>
        </thead>
        <tbody class="candidateList"></tbody>
      </table>
    </div>
  </div> 
</div>
```
후보자 리스트에 붙일 table태그를 생성하고 컨트랙트 주소를 출력할 p태그를 만듭니다.

## Voting.sol 수정
후보자 리스트를 출력하기 위해서는 현재 몇명 등록되어 있는지 candidateList의 크기 정보가 필요합니다. getCandidateListLength() 함수를 추가합니다.

```
function getCandidateListLength() public view returns (uint){
  return candidateList.length;
}
```
 
Voting.sol을 수정했으면 컴파일, 배포를 실행합니다.

## app.js 수정

render함수를 수정합니다.

```
render: function(){
    var loader = $('.loader');
    var contents = $('.contents');
    var ownerTag = $('.owner');

    var votingInstance;

    loader.show();
    contents.hide();

    App.contracts.Voting.deployed().then(function(instance){
      votingInstance = instance;
      votingInstance.getOwner.call().then(function(owner){
        ownerTag.html("Contract Owner is: " + owner);
      });

      return votingInstance.getCandidateListLength.call();
    }).then(function(count){
      var candidateCount = count.toNumber();
      var candidateList = $('.candidateList');

      for(var i=0; i < candidateCount; i++){
        votingInstance.getCandidate(i).then(function(candidate){
          var name = candidate[0];
          var voteCount = candidate[1];
          var candidateTemp = "<tr><th>" + name + "</th><td>" + voteCount + "</td></tr>"; 
          candidateList.append(candidateTemp);
        });
      }

    }).then(function(){
      loader.hide();
      contents.show();
    });
  }
```
getCandidateListLength함수를 호출 한 후, 후보자 수에 맞게 테이블에 후보자의 이름과 보팅 수를 표시합니다. 
