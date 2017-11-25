DeepDive.training

deepdive-eth-101

![image alt text](image_0.png)

A deep dive into blockchain development using the Ethereum blockchain.

2017-11-24

By [Marc Buma](http://www.bumos.nl/) & [Bart Roorda](http://bartroorda.nl/)

[DeepDive.training](http://deepdive.training)

DeepDive.training - overview & goals

[[TOC]]

Let’s move some money around

# Mission 1: Start your engines

Goal: getting started

**We are going to create transactions**. What do we need?

We’ll need **a local node **to be able to experiment with the Ethereum blockchain. We use geth, an Ethereum client written in Go.

The local node will interact with a **test RPC simulator** or the **R****opsten Ethereum test net**. 

The test RPC simulator (testrpc) creates a private blockchain with a single node (you). Any transaction you commit to this network is immediately confirmed on the blockchain. This is ideal for testing and building.

The Ropsten Ethereum testnet is a fully functional, decentralized blockchain with the same infrastructure as the main net. You use the testnet as a testing environment before you bring your code onto the main net. In contrast to the main net, Ether that lives on the Ropsten testnet has no value and can be easily mined on your own PC.

To make it easy you’ll create a Docker container containing all tools you need. This allows you to work with the Ethereum blockchain from a JavaScript console.

What are we waiting for.. Let’s install the basics!

<table>
  <tr>
    <td>geth: Ethereum client written in Go https://github.com/ethereum/go-ethereum/wiki/geth 

testrpc: A test RPC client/simulator https://github.com/trufflesuite/ganache-cli

ropsten: testing environment https://ethereum.stackexchange.com/a/13536 </td>
  </tr>
</table>


## Install & run the environment 

### Clone the git repository

Clone the git repository that contains a Docker container with geth & truffle:

**git clone ****[https://github.com/deepdivetraining/geth-truffle-docke**r](https://github.com/deepdivetraining/geth-truffle-docker)** deepdive-eth-101-base && cd deepdive-eth-101-base**

(copy on a single line)

### Run the docker containers

Now **run the docker containers**:

**docker-compose up -d**

The client will start syncing a light version of the blockchain. This saves resources on your computer and limits the time required to download the blockchain. The **-d** (daemon) flag tells docker to start the processes in the background.

Next check the syncing progress by looking at the log files with the command

**	d****ocker logs geth **

<table>
  <tr>
    <td>truffle: fast Ethereum RPC client for testing and development

light client: A Client that downloads only a small part of the blockchain.</td>
  </tr>
</table>


In the first part of this workshop the go-ethereum client (**geth) **is used to access the blockchain. The geth client has been installed inside of the docker container. 

## Login into the geth docker container

First create a command prompt in the docker container. **Open a new terminal window** and issue the following commands to access a command shell in the docker container:

# Dive into the Docker container

**docker exec -it geth sh**

## Lookup the accounts on RPC Testnet

# Create a command prompt for accessing the 

# rpc testnet # blockchain

**geth attach http://<your ip address>:8545**

# show the accounts that are available

**eth.accounts**

# check out the amount of Ether in the first account

**web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")**

# exit the command prompt

**exit**

Note: Due to a bug in the docker environment, you need the IP address of your laptop for connecting to this testnet. You can check your ip address with the ifconfig (linux) or ipconfig (windows) command from a command prompt:

**ifconfig | grep ****"****192.****"**

## Show the latest block on Ropsten Testnet

# Create a command prompt for accessing the 

# ropsten testnet # blockchain

**geth attach http://localhost:8544**

**Test the installation** by typing the following command on the geth command prompt:

**	eth.getBlock('latest').number**

This should give the number of the most recent block on the Ropsten Ethereum Testnet. You can check this in the output of the first terminal window ("number" in the last output line) or through an Ethereum blockchain explorer ([http://ropsten.etherscan.io](http://ropsten.etherscan.io))

## Celebrate!

You are now all set to start experimenting with the Ethereum blockchain and smart contracts!

# Mission 2: Spend some cash

Goal: be able to create transactions and put them on the blockchain

In order to do something on the Ethereum blockchain, you need some cash. In this mission you will acquire some Ether and learn about accounts and transfers. These are the basic operations that you need to master first.

In this mission you will do this in two ways: first using an online wallet to get a good impression of the steps that are involved, secondly by issuing javascript commands. 

## Create your wallet

* Go to MyEtherWallet.com, choose a password and create a wallet. This generates a public/private key combination. Save the private key in an encrypted keystore file on disk (can only be unlocked with the password), next **store the private key at a safe location**. Also make a note of your public wallet address. You will be needing these two throughout the exercises. Anyone with access to your private key can spend your Ethers!

## Transfer some test Ether (using MyEtherWallet)

Get a paper wallet with test Ether. Sign in into MyEtherWallet with the information from the paper wallet to transfer some of the test Ether to your own wallet. 

**While the transaction is being processed:**

* While the transaction is being processed, use http://ropsten.etherscan.io to track the transaction:

    * What states does the transaction go through before the ether appears in your wallet?

    * Can you track where the coins on your paper wallet originate?

    * What do the following terms mean: block number 

## Transfer some test Ether (using geth and Test RPC)

Now it is time to take a look at the Ethereum blockchain from the inside. For this you need to start the geth console on the Ropsten testnet. 

	# start geth console (testrpc)

**docker exec -it geth sh**

**geth attach http://<your ip address>:8545**

First check what accounts are available on the local wallet. 

	**eth.accounts**

And how much ether is in the first account

	**web3.fromWei(eth.getBalance(eth.accounts[0]), 'ether');**

<table>
  <tr>
    <td>Wei: Wei is a denomination, like cents to Dollars. 1 ether = 10^18 wei

TestRPC: blocks are immediately mined when you send a transaction.</td>
  </tr>
</table>


In the test environment you can refer to eth.accounts[x] to get the address for each account. Now you can transfer some money! 

**amount = web3.toWei(1, "ether");**

**eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value: amount})**

You can **_eth.getTransaction()_** and **_eth.getBlock()_** to inspect what has happened behind the scenes. What are the new balances for each account? And what happens in the docker log when you do transactions? (execute **_docker logs testrpc -f_** in a new terminal window)

Do you think it is wise to transfer ether from this account to the account that you created with myetherwallet? Why?

Finally, close the geth console before you proceed.

**exit**

## Transfer some test Ether (using geth and Ropsten Testnet)

Now it is time to move to the Ropsten Test network. This means that transactions are sent to the blockchain and are checked and mined by other nodes on the network. You can use the online blockchain explorer ([http://ropsten.etherscan.io](http://ropsten.etherscan.io)) to look from the outside.

	# start geth console (Ropsten Testnet)

**geth attach http://localhost:8544**

First, import your paper wallet account into the local wallet (use an easy password for now, write down the key somewhere!)

**personal.importRawKey(****'****<private key>****'****, '<password>') **

You can check the result with your paper wallet address to double check. 

Next, unlock the account so that you can transfer funds. Set duration to 0 to keep it unlocked until the end of the session.

	

	**personal.unlockAccount('<address>', 'passwor****d'****, duration)** 

Now you can create a new account to transfer money to. Write down the address and password for the account. 

**personal.newAccount()**

Use the same command as before to transfer some Ether to the account you created with myetherwallet. Does the Ether appear in your online wallet afterwards?

**eth.sendTransaction({from:<address>, to:<address>, value: <numberofWei>})**

Now you can track the transaction either using eth.getTransaction() or using the external site. 

The javascript commands that you have used are known as the Geth Management API’s. You can read more at [ttps://github.com/ethereum/go-ethereum/wiki/Management-APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)

<table>
  <tr>
    <td>There is no way to export unencrypted private keys from the geth console. As a backup measure you can copy the encrypted keyfile in from the docker image to a safe location. You can then use the online wallet from myetherwallet.org  together with the password to retrieve the private key. (please keep in mind that these files disappear if you remove the docker image!)

Alternative: transfer the funds back to your paper wallet….</td>
  </tr>
</table>


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

![image alt text](image_1.png)

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

**	ifconfig | grep "192."**

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

1. **compiledCode.contracts[****'****:Voting****'****].bytecode**= the bytecode that is the result of compiling your Voting.sol source code. This code will be deployed to the blockchain.

2. **compiledCode.contracts[':Voting'].interface**= the interface or template of the contract (called "ABI") which tells the contract user what methods are available in the contract.

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

# Mission 4 - Fun with blockchains

A lot of people have only recently encountered blockchain technology. In practice, the technologies that combine into blockchain and other distributed ledgers have been around for the past two decades. The Bitcoin network began in 2009 when Satoshi Nakamoto "mined" the first Bitcoins and has thus been around for 8 years already.

One fun thing you can do is dive in the blockchain and lookup some memorable transactions and moments. Can you figure out what is special about these events?

* [Bitcoin transaction 4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b](https://blockchain.info/tx/4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b)

* [https://bitcointalk.org/index.php?topic=137.msg1195#msg1195](https://bitcointalk.org/index.php?topic=137.msg1195#msg1195)

* [https://blockchain.info/address/1GBwk2YJMDFqSVhTKygH8zUwV7jdoJhHHH](https://blockchain.info/address/1GBwk2YJMDFqSVhTKygH8zUwV7jdoJhHHH)

* [Len Sassaman](http://en.wikipedia.org/wiki/Len_Sassaman)

* [https://blockchain.info/largest-recent-transactions](https://blockchain.info/largest-recent-transactions)

As data can be stored in the blockchain, another fun trick is searching through texts that have been stored in the bitcoin blockchain. These texts are collected on the site [https://bitcoinstrings.com](https://bitcoinstrings.com/). By using a smart google filter "site:[https://bitcoinstrings.com](https://bitcoinstrings.com/) <subject>" you can search the blockchain for yourself. [Try it out]( https://www.google.nl/search?client=safari&rls=en&q=site:https://bitcoinstrings.com cappuccino&ie=UTF-8&oe=UTF-8&gfe_rd=cr&dcr=0&ei=9R8XWoDcCaTPXti1qNAB)!

Finally, if you like solving puzzles, this might be one to try. 

![image alt text](image_2.jpg)

This painting from artist Marguerite Christine, ([Coin_Artist on Twitter](https://twitter.com/coin_artist)) contains a series of hidden clues that together form the private key for a bitcoin wallet containing 4.7 BTC. This can be yours if you manage to solve the puzzle. Although this represented a modest amount of money in 2015 when it was created, [it now represents a prize of more than 30.000 euro](https://www.reddit.com/r/Bitcoin/comments/31bho4/new_arg_puzzle_48btc_prize/). 

## Thanks for participating!

How did you like this course? Do you have feedback? Please let us know!

**[info@deepdive.trainin**g](mailto:info@deepdive.training)

