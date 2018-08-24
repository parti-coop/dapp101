# Truffle 프로젝트 시작
 
트러플 프로젝트를 위한 폴더를 만들고 이동합니다.
```
mkdir voting
cd voting
```

비어있는 트러플 프로젝트를 생성할 때는 truffle init으로 합니다만

스캐폴더를 이용하기 위해서 
```
truffle unbox pet-shop
```

성공적으로 완료가 되면 contracts, migrations, test, src 폴더가 생성되며
truffle.js, bs-config.js 파일이 생성됩니다.
(깃헙에서는 code폴더 안에 들어가 있습니다.)

## 트러플 네트워크 설정

프로젝트에서 사용할 네트워크를 설정합니다. 
truffle.js를 열어서 아래와 같이 설정되어 있는지 확인합니다.

```
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    }
  }
};
```

2장에서 설치한 ganache 네트워크가 포트를 7545를 사용하고 있기 때문에 따로 변경할 점은 없습니다.
네트워크와 잘 연결이 됐는지 확인해보기 위해 아래 마이그레이트 명령어를 입력합니다.

```
truffle migrate
```

아래와 같은 문구가 나오면 성공입니다.
```
Compiling ./contracts/Migrations.sol...
Writing artifacts to ./build/contracts

Using network 'development'.

Network up to date.
```
 
## 컨트랙트 생성하기

트러플에서는 컨트랙트를 생성하는 명령어를 제공합니다.

```
truffle create contract Voting
```

contracts 폴더에 보면 Voting.sol이 생성된 것을 확인할 수 있습니다.
Votign.sol파일을 열면 아래와 같이 구성되어 있습니다.

```
pragma solidity ^0.4.22;

contract Voting {
  constructor() {
  }
}
```

**pragma solidity ^0.4.22;** 줄은 솔리디티 언어를 명시 0.4.22버전 이상에서 사용가능하다는 걸 뜻합니다. 0.4.22 이전 버전에서는 동작안할 수도 있다는 점~

**contract**는 예약어로 하나의 컨트랙트를 나타냅니다. (일반적으로 다른 언어의 class처럼 사용합니다.)

**constructor**는 생성자로 사용됩니다. 생성자는 컨트랙트를 배포할 때 처음으로 호출되는 함수입니다. (class의 생성자와 똑같습니다.)

아래와 같이 수정합니다.

```
pragma solidity ^0.4.22;

contract Voting {
  address public owner;
  constructor() {
    owner = msg.sender;
  }
}
```

address형을 가진 변수 owner를 접근제한자 public과 같이 선언했습니다.
솔리디티에서는 어드레스형이라는 특이한 형을 지원하고 있습니다. owner 변수를 생성자에서 msg.sender r값으로 초기화 시켜줍니다.

msg는 솔리디티에서 제공하는 특별한 변수로 전역 네임 스페이스를 갖습니다. 언제든 사용할 수 있다는 뜻입니다. msg.sender는 메세지를 보낸 주소를 값으로 가지고 있습니다. 해당 프로그램에서는 컨트랙트를 배포하는 주소를 owner변수에 저장하는 걸 뜻합니다.
제대로 동작하는 지 알아보겠습니다.

먼저 컴파일을 합니다.
```
truffle compile
```

오류가 없는지 알아봅니다. 컴파일 오류가 없으면 컨트랙트를 배포할 때 사용하는 마이그레이션 파일을 만들겠습니다.

```
truffle create migration Voting
```

migrations폴더에 ~_voting.js 가 생성됩니다.
해당 파일을 열어서 아래와 같이 작성합니다.

```
var Voting = artifacts.require("Voting");

module.exports = function(deployer) { 
  // Use deployer to state migration tasks. 
  deployer.deploy(Voting); 
};
```

트러플에서는 컨트랙트를 사용할 때 **artifacts.require**를 사용해서 컨트랙트 정보를 가져옵니다. 파라미터로 컨트랙트 이름을 사용합니다.

**deployer.deploy**를 사용해서 컨트랙트를 배포합니다.
파일 작성이 완료되었으면 아래 명령어를 입력합니다. 

```
truffle migrate
```
 
컴파일 한 컨트랙트를 네트워크에 배포합니다. 
컨트랙트 배포가 끝났으면 정상적으로 배포가 됐는지 확인해보겠습니다.

```
truffle console
```
를 입력해서 트러플 콘솔로 들어갑니다.

```
Voting.deployed().then(function(instance) { data = instance });
data
```

를 입력해보면 배포된 컨트랙트 정보가 출력됩니다. 
Voting 컨트랙트의 owner변수를 출력해보겠습니다.
```
data.owner();
0xf4b4ca0e0858de41b60ce0d63fa150609894bf63
```
위와 같이 ganache의 coinbase 주소가 출력되면 성공입니다.

(coinbase란? 이더리움 네트워크가 채굴에 성공했을 때 보상을 받는 주소를 말합니다. 디폴트로 가장 첫 번째 주소로 설정되어 있습니다.)

coinbase의 주소는 각자가 설치한 테스트 네트워크에 따라 다릅니다.
Ganache의 첫 번째 주소 값이 결과값으로 나오면 제대로 배포가 된 겁니다.
제 Ganache 화면을 보시면 첫 번째로 나온 주소가 콘솔에서 출력된 걸 확인할 수 있습니다.

![Ganache 실행화면](image/0201.png)

