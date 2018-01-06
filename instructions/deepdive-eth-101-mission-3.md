Contract anyone?

# Mission 3: Deploy a voting app on TestRPC

Goal: be able to use a smart contract - plus deploy one yourself

**In this mission we will learn about smart contracts**. What are smart contracts, how can you use one and how to deploy your own?

We will start with explaining the the basic concepts. Then, we will start using a voting contract.

Have fun exploring!

<table>
  <tr>
    <td>geth: Ethereum client written in Go https://github.com/ethereum/go-ethereum/wiki/geth 

testrpc: A test RPC client/simulator https://github.com/trufflesuite/ganache-cli

ropsten: testing environment https://ethereum.stackexchange.com/a/13536 </td>
  </tr>
</table>


## Smart contracts?

First a bit of theory. How is programming on blockchains different from a standard client-server model? What are smart contracts anyway?

### #snorks

There has been a lot of debate about the term ‘smart contract’. A smart contract is not smart, and it is not necessarily a contract. Someone [suggested](https://github.com/ethereum/EIPs/issues/66) to rename ‘contract’ with ‘snork’, to prevent confusion. No consensus yet.

![image alt text](image_3.png)

*A ***_smart contract _***is a set of promises, specified in digital form, including protocols within which the parties perform on these promises.* ([source](http://www.fon.hum.uva.nl/rob/Courses/InformationInSpeech/CDROM/Literature/LOTwinterschool2006/szabo.best.vwh.net/smart_contracts_2.html))

For example, you can write code functions that you can interact with using tokens. If a token value is received by a function, the function will execute the thing it’s programmed to execute. The contract on the blockchain self-enforces the pre-programmed way of execution.

One of the interesting examples of a smart contract is the [ERC20 token standard](https://theethereum.wiki/w/index.php/ERC20_Token_Standard).

Everyone can deploy a contract without permission on a public blockchain. A kid of 13 can start a bank in 15 lines of code. People can build on smart contracts of others. Permissionless innovation.

There are many distributed systems that implement smart contracts. To give you two examples:

* **Bitcoin**** **provides a simple (Turing incomplete) Script language that allows the creation of custom smart contracts on top of Bitcoin like multi signature accounts, payment channels, escrows, time locks, atomic cross-chain trading, oracles, or multi-party lottery with no operator.

* **Ethereum** implements a nearly Turing-complete language on its blockchain, a prominent smart contract framework.

 

In this mission we will see and use an example of a smart contract. We’ll create a simple Ethereum voting dApp.

### Note: Know what you don’t know

Creating a smart contract that handles money is risky. If there’s a bug in your deployed code, it’s impossible to change it. Every now and then we see examples of this. [The DAO](https://en.wikipedia.org/wiki/The_DAO_(organization)#History) was an interesting one. The recent Parity multisig wallet bug [[1]](https://github.com/paritytech/parity/issues/6995) [[2]](https://tweakers.net/nieuws/131633/bug-in-parity-wallet-bevriest-miljoenen-euros-aan-ethereum.html) is another example. 

If there are bugs in your code you could lose a lot of people’s money. Or you can lose access to important data. Be careful when you deploy smart contracts to a live network.

## Our first voting dApp

As a developer the best way to learn a new language is by building fun mini applications. We will create and interact with this [voting app](https://github.com/maheshmurthy/ethereum_voting_dapp/blob/master/chapter1/Voting.sol).

The goal of this mission to deploy the contract into the development environment. In the process we will learn how to write and compile a contract, and how to interact with it.

## Let’s vote!

### Get testrpc running

Just like in Mission 2 ("Let’s spend some cash") we will use the in-memory blockchain called testrpc as a part of our development setup.

If you do not have the Docker containers running, please navigate to your *deepdive-eth-101-base* folder and start the containers with the command:

**docker-compose up -d**

### Use testnet in Docker

As we have seen in Mission 1 ("Start your engines"), we can interact with testrpc using a JavaScript command prompt. We will execute code from the *truffle* container:

1. Make sure the Docker containers are running (check with **docker ps**)

2. Open an new terminal tab or window

3. **docker exec -it truffle sh**

You are now ready to create your first contract.

### Write a contract

We will use the [Solidity](https://solidity.readthedocs.io/en/latest/) programming language to write the contract. Solidity is an object oriented programming language like JavaScript. You could see a smart contract as a ‘class’, like in most OOP languages.

We are going to use the following contract code.

pragma solidity ^0.4.18;

// We have to specify what version of compiler this code will compile with

contract Voting {

  /* mapping field below is equivalent to an associative array or hash.

  The key of the mapping is candidate name stored as type bytes32 and value is

  an unsigned integer to store the vote count

  */

  

  mapping (bytes32 => uint8) public votesReceived;

  

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).

  We will use an array of bytes32 instead to store the list of candidates

  */

  

  bytes32[] public candidateList;

  /* This is the constructor which will be called once when you

  deploy the contract to the blockchain. When we deploy the contract,

  we will pass an array of candidates who will be contesting in the election

  */

  function Voting(bytes32[] candidateNames) public {

    candidateList = candidateNames;

  }

  // This function returns the total votes a candidate has received so far

  function totalVotesFor(bytes32 candidate) view public returns (uint8) {

    require(validCandidate(candidate));

    return votesReceived[candidate];

  }

  // This function increments the vote count for the specified candidate. This

  // is equivalent to casting a vote

  function voteForCandidate(bytes32 candidate) public {

    require(validCandidate(candidate));

    votesReceived[candidate] += 1;

  }

  function validCandidate(bytes32 candidate) view public returns (bool) {

    for(uint i = 0; i < candidateList.length; i++) {

      if (candidateList[i] == candidate) {

        return true;

      }

    }

    return false;

  }

}

To make it easy we already made a file for it. Execute the following command to see the contents of Voting.sol:

**cd Voting && cat Voting.sol**

The Voting contract has a** constructor **which initializes an array of candidates to vote on.

Note: Because of deployed code in the blockchain is immutable, the constructor is invoked only once (at the moment you deploy the contract to the blockchain).

Next to that there you see **three method****s**:

* **totalVotesFor()** returns the candidate’s total votes for a 

* **voteForCandidate()** increments the candidate’s vote count

* **validCandidate()** checks if the candidate can actually be voted for

Now we have our contract, it’s time to compile the code and deploy it to testrpc blockchain.

### Compile the contract to bytecode

web3js Is a library which lets you interact with the blockchain through RPC. We will use this library to deploy our application and interact with it.

First we install two packages:

* fs, so we can read Voting.sol from our filesystem.

* solc, a Solidity code compiler

Install these packages using npm (node package manager):

  npm install fs solc

We need your local IP address in the near future. Find it by using:

**  ifconfig | grep "192."**

Now, start the node console, so we can initialize the solc and web3 objects.

  

**node**

The following code snippets will be executed in the node console:

**Web3 = require('web3')**

**web3 = new Web3(new Web3.providers.HttpProvider("****[http://192.168.YOUR.IP:854**5](http://192.168.178.17:8545)**"));**

**web3 = new Web3(new Web3.providers.HttpProvider("****[http://192.168.178.17:854**5](http://192.168.178.17:8545)**"));**

The web3 object is now initialized, so it can interact with the blockchain.

Let’s test if everything works fine:

**accounts = []**

**web3.eth.getAccounts((error, result) => { console.log(result); accounts = result; })**

The command above returns all accounts in the blockchain. (Press <enter> so you can type in your console again).

Now, to compile the contract, load the code from Voting.sol into a string variable:

**code = fs.readFileSync('Voting.sol').toString()**

Then compile it:

**solc = require('solc')**

**compiledCode = solc.compile(code)**

Congratulations, you’ve successfully compiled your first contract!

The compiledCode variable contains two important fields:

1. **compiledCode.contracts[****'****:Voting****'****].bytecode**

= the bytecode that is the result of compiling your Voting.sol source code. This code will be deployed to the blockchain.

2. **compiledCode.contracts[':Voting'].interface**

= the interface or template of the contract (called "ABI") which tells the contract user what methods are available in the contract.

Now your Solidity contract is well compiled, we can deploy it to the blockchain.

### Upload your contract to the blockchain

Let’s deploy the contract.

VotingContract is your ‘contract’ object. While still in your node console, get the bytecode & abi code:

**byteCode = compiledCode.contracts[':Voting'].bytecode**

**abi = JSON.parse(compiledCode.contracts[':Voting'].interface)**

We now create a [‘contract’ object](https://web3js.readthedocs.io/en/1.0/web3-eth-contract.html#new-contract). The candidates who will compete in today’s election are Anna, Alice Bob.

**VotingContract = new web3.eth.Contract(abi)**

Ok. We have a contract object. Let’s now deploy the thing:

**# Helper function**

**h = (ascii) => web3.utils.asciiToHex(ascii)**

**c = VotingContract.deploy({ data: byteCode, arguments: [[h('Anna'), h('Alice'), h('Bob')]] })**

As we have seen in the constructor of Voting.sol, the first argument is an array of candidates to vote on. Next to that we have the **data**: The compiled bytecode which we deploy to the blockchain.

VotingContract.deploy(...) returns a transaction object. We will now send the initial transaction to the smart contract using our account address, so the contract knows we are the owner:

**deployedContract = c.send({ from: accounts[0], gas: 4700000 }, (error, result) => { console.log(result); })**

These two arguments were given to the send() function:

* **from**: The owner of the contract (the one that deploys it)

* **gas**: The amount of money that you spend to interact with the blockchain (see: [gas](https://docs.google.com/spreadsheets/d/13br0xLllFS1fkKy65y9QVtoXGhY1HT_N4ryFqYy_WoI/edit#gid=0))

The transaction to the smart contract now has been executed. 

The contract is deployed. We create a contract instance to interact with the contract:

**contractAddress = ''**

**deployedContract.then(function(newContractInstance){ contractAddress = newContractInstance.options.address; });**

Let’s see the address of the contract, that we use to identify our contract among all others on the blockchain:

**contractAddress**

We set the address on the contract object:

**VotingContract.options.address = contractAddress**

With this we can finally interact with the blockchain → 

### Interact with the blockchain / let’s vote!

Try out the following commands:

  # See votes for Anna

**VotingContract.methods.votesReceived(h('Anna')).call((e, r) => console.log(r))**

  # Vote on a candidate (well return a transactionHash)

**VotingContract.methods.voteForCandidate(h('Anna')).send({ from: accounts[0] }).then(console.log)**

# Vote again

**VotingContract.methods.voteForCandidate(h('Anna')).send({ from: accounts[0] }).then(console.log)**

# How many votes does Anna now have?

**VotingContract.methods.votesReceived(h('Anna')).call((e, r) => console.log(r))**

Every time you vote for a candidate, you get back a transaction id. The transaction id proofs that this transaction occurred. You can refer back to this at any time in the future. Note that the transaction is immutable. Immutability is one of the big advantages of blockchains such as Ethereum.

### The final touch

The only thing that rests is to make the interaction a bit more beautiful. This is something you could do in the next DeepDive course!

What to do next?
