# 컨트랙트 주인만 후보자와 유권자만 등록

후보자와 유권자 등록은 컨트랙트를 배포한 주인만 등록할 수 있게 변경해보도록 하겠습니다.

## Vointg.sol 수정

require를 사용해서 구현할 수도 있지만 modifier라는 것을 이용해서 구현합니다.
modifier는 다른 함수 실행 전에 수행되는 wrapper라고 생각하셔도 됩니다.


```
modifier onlyOwner(){
  require(msg.sender == owner);
  _;
}
```

require문 아래에 있는 **_;**은 require문을 통과하면 이후 명령어를 실행시킵니다.

modifier가 정의를 했으면 onlyOwner가 필요한 함수에 추가합니다. addCandidate, addVoter에 추가하겠습니다.

```
function addCandidate (string name) public onlyOwner {
  candidateList.push(Candidate(name,0));
}

function addVoter (address _voter) public onlyOwner{
  voterList[voterCount] = Voter(_voter, true);
  voterCount++;
}
```

modifier를 명시하면 함수 실행 전에 특정 기능을 실행시킬 수 있습니다.

트러플 콘솔로 이동해서 컨트랙트를 배포하지 않은 다른 주소를 이용해서 위의 함수를 실행시키면 revert에러를 내는 것을 확인할 수 있습니다.

```
truffle(development)> i.addCandidate('park',{from:web3.eth.accounts[1]});
Error: VM Exception while processing transaction: revert
    at XMLHttpRequest._onHttpResponseEnd (/usr/local/lib/node_modules/truffle/build/webpack:/~/xhr2/lib/xhr2.js:509:1)
    at XMLHttpRequest._setReadyState (/usr/local/lib/node_modules/truffle/build/webpack:/~/xhr2/lib/xhr2.js:354:1)
    at XMLHttpRequestEventTarget.dispatchEvent (/usr/local/lib/node_modules/truffle/build/webpack:/~/xhr2/lib/xhr2.js:64:1)
    at XMLHttpRequest.request.onreadystatechange (/usr/local/lib/node_modules/truffle/build/webpack:/~/web3/lib/web3/httpprovider.js:128:1)
    at /usr/local/lib/node_modules/truffle/build/webpack:/packages/truffle-provider/wrapper.js:134:1
    at /usr/local/lib/node_modules/truffle/build/webpack:/~/web3/lib/web3/requestmanager.js:86:1
    at Object.InvalidResponse (/usr/local/lib/node_modules/truffle/build/webpack:/~/web3/lib/web3/errors.js:38:1)
```

이상으로 dapp101 Park's Voting이 끝났습니다.
기본적인 스마트 컨트랙트 구현과 solidity언어의 특징,트러플을 사용하는 법, 이벤트를 알아보았습니다.

해보시면서 발견한 오타, 건의사항은 폴리퀘로 주셔도 좋고 이슈로 남겨주셔도 좋습니다.

** by 3D Activist 켄타 **
- 블록체인과 관련된 정보와 이야기를 아래 빠띠에서 나누고 있습니다. 블록체인 관련해서 이야기나누고 싶은신 분은 언제나 환영입니다. :)

[블록체인 빠띠 둘러보기](https://parti.xyz/p/blockchain)

