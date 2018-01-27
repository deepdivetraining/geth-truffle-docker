# Mission 1: Start your engines

**We are going to create transactions**. What do we need?

We'll need a local node to be able to experiment with the Ethereum blockchain. We use **geth**, an Ethereum client written in Go.

<table>
  <tr><td><a href="https://github.com/ethereum/go-ethereum/wiki/geth"><b>geth:</b></a> Ethereum client written in Go</td></tr>
</table>

The local node will interact with a **test RPC** simulator or the **Ropsten** Ethereum test net. 

The test RPC simulator (testrpc) creates a private blockchain with a single node (you). Any transaction you commit to this network is immediately confirmed on the blockchain. This is ideal for testing and building.

<table>
  <tr><td><a href="https://github.com/trufflesuite/ganache-cli"><b>testrpc:</b></a> A test RPC client/simulator</td></tr>
</table>

The Ropsten Ethereum testnet is a fully functional, decentralized blockchain with the same infrastructure as the main net. You use the testnet as a testing environment before you bring your code onto the main net. In contrast to the main net, Ether that lives on the Ropsten testnet has no value and can be easily mined on your own PC.

<table>
  <tr><td><a href="https://ethereum.stackexchange.com/a/13536"><b>ropsten:</b></a> Testing environment</td></tr>
</table>

To make it easy you'll create a Docker container containing all tools you need. This allows you to work with the Ethereum blockchain from a JavaScript console.

What are we waiting for.. Let's install the basics!

## 1. Install & run the environment 

### 1.1 Clone the git repository

Clone the git [repository](https://github.com/deepdivetraining/geth-truffle-docker) that contains a Docker container with geth & truffle into the directory **`deepdive-eth-101-base`**

    git clone https://github.com/deepdivetraining/geth-truffle-docker deepdive-eth-101-base

Now descend into the new directory

    cd deepdive-eth-101-base

### 1.2. Start the Docker containers

Now **start** the Docker containers:

    docker-compose up -d

The client will start syncing a light version of the blockchain. This saves resources on your computer and limits the time required to download the blockchain. The **-d** (daemon) flag tells docker to start the processes in the background.

<table>
  <tr><td><b>light client:</b> A Client that downloads only a small part of the blockchain.</td></tr>
</table>

To see the running Docker containers, execute:

    docker ps

<table>
  <tr><td><b>truffle:</b> Fast Ethereum RPC client for testing and development</td></tr>
</table>

Check the syncing progress by looking at the log files with the command:

    docker logs geth

In the first part of this workshop the go-ethereum client (**geth**) is used to access the blockchain. The geth client has been installed inside of the docker container.

## 2. Login into the geth docker container

**Open a new terminal window** and issue the following commands to access a command shell in the docker container:

    docker exec -it geth sh

Now we have a command prompt in the docker container.

## 3. Lookup the accounts on RPC Testnet

Create a command prompt for accessing the rpc testnet blockchain:

    geth attach http://<your ip address>:8545

Show the accounts that are available:

    eth.accounts

Check out the amount of Ether in the first account:

    web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")

Exit the command prompt:

    exit

Note: Due to a bug in the docker environment, you need the IP address of your laptop for connecting to this testnet. You can check your ip address with the ifconfig (linux) or ipconfig (windows) command from a command prompt:

    ifconfig | grep "192."

## 4. Show the latest block on Ropsten Testnet

Create a command prompt for accessing the ropsten testnet blockchain:

    geth attach http://localhost:8544

Test the installation by typing the following command on the geth command prompt:

    eth.getBlock('latest').number

This should give the number of the most recent block on the Ropsten Ethereum Testnet. You can check this in the output of the first terminal window ("number" in the last output line) or through an Ethereum blockchain explorer ([http://ropsten.etherscan.io](http://ropsten.etherscan.io))

## 5. Celebrate!

You are now all set to start experimenting with the Ethereum blockchain and smart contracts!

____

=> **[Mission 2](deepdive-eth-101-mission-2.md)**
