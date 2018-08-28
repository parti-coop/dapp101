# 컨트랙트 계속 작성

## owner 변수 접근 변경과 get함수 추가
3장에서는 owner변수에 직접 접근해서 값을 가져왔는데 이 번에는 get함수를 만들어서 접접근해봅니다. 코드를 아래와 같이 변경합니다.
 
```
pragma solidity ^0.4.22;

contract Voting {
  address private owner;
  constructor() public{
    owner = msg.sender;
  }

  function getOwner() public view returns (address){
    return owner;
  }
}
```

달라진 부분은 owner의 접근 제한을 private 로 변경하고 getOwner함수를 추가하였습니다.

getOwnber함수에서 사용된 예약어를 살펴보면,
**public**은 접근 제한 예약어, **view**는 해당 함수가 read only라는 걸 나타냅니다.(이더리움에서는 read only라고 명시된 함수를 사용할 때는 더 빠르게 실행합니다. 라고 하네요.) **returns (address)** 는 address형의 변수 하나를 반환한다는 의미입니다.

컴파일 하고, 마이그레이션 합니다. 
( **!주의사항** 코드를 변경하고 마이그레이션을 실행할 때는 --reset옵션을 사용해서 처음부터 마이그레이션을 하는 걸 권해드립니다.)

```
truffle compile
truffle migrate --reset
```

트러플 콘솔로 들어갑니다.
```
truffle console
Voting.deployed().then(function(ins){i=ins;});
i.getOwner()
```

3장과 결과가 같으면 성공입니다.
3장처럼 직접 변수에 접근하면 'undefined' 결과가 나옵니다.

## 후보자 등록하고 검색 기능 추가
 
```
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
}
```

후보자는 **struct** 키워드를 사용해서 Candidate 구조체로 선언합니다. Candidate 구조체를 선언합니다. Candidata에는 string name과 uint8 voteCount를 요소로 갖습니다.
uint8 은 정수형이며 변수의 크기가 8비트를 의미합니다. 솔리디티에서는 uin8 ~ unit256 까지 지원합니다. candidat를 원소를 갖는 배열을 **[]** 예약어를 이용해 선언합니다.

후보자를 등록하는 함수 addCandidate는 파라미터로 name을 받고 Candidate()를 통해서 새로운 후보자를 생성하고 배열의 push 함수를 이용해서 candidateList에 추가합니다.

getCandidate함수는 후보자의 아이디를 받고 해당하는 후보자의 이름과 보팅 수를 반환합니다.
솔리디티에서는 반환 값을 여러 개를 가질 수 있습니다. **returns**에서 반환 형과 수를 명시합니다.

truffle compile, truffle migrate를 수행하고 트러플 콘솔로 들어갑니다.
park라는 후보자를 addCandidate함수를 사용해서 등록합니다.

```
Voting.deployed().then(function(ins){i=ins});
i.addCandidate('park');
```

잘 등록이 됐는지 확인해봅니다.
```
i.getCandidate(0);
```

getCandidate(0)를 이용해서 후보자의 정보를 받으면 아래와 같이 출력됩니다.

```
[ 'park', BigNumber { s: 1, e: 0, c: [ 0 ] } ]
```

string인 이름은 잘 출력이 되는데 정수형이 BigNumber 객체로 반환되는 걸 확인할 수 있습니다.
이렇게 BigNumber로 객체가 반환될 때는 toNumber()함수를 사용하면 숫자로 출력시킬 수 있습니다.

```
i.getCandidate(0).then(function(result){name = result[0]; count=result[1]});
count.toNumber();
```

0이 출력되면 성공입니다.
