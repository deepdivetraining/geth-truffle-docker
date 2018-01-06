## Mission 1: Start your engines

*Goal: getting started*

**We are going to create transactions**. What do we need?

<table>
  <tr><td><b>geth:</b> Ethereum client written in Go <a href="https://github.com/ethereum/go-ethereum/wiki/geth">https://github.com/ethereum/go-ethereum/wiki/geth</a></td></tr>
  <tr><td><b>testrpc:</b> A test RPC client/simulator <a href="https://github.com/trufflesuite/ganache-cli">https://github.com/trufflesuite/ganache-cli</a></td></tr>
  <tr><td><b>ropsten:</b> testing environment <a href="https://ethereum.stackexchange.com/a/13536">https://ethereum.stackexchange.com/a/13536</a></td></tr>
</table>

We'll need **a local node** to be able to experiment with the Ethereum blockchain. We use geth, an Ethereum client written in Go.

The local node will interact with a **test RPC simulator** or the **R****opsten Ethereum test net**. 

The test RPC simulator (testrpc) creates a private blockchain with a single node (you). Any transaction you commit to this network is immediately confirmed on the blockchain. This is ideal for testing and building.

The Ropsten Ethereum testnet is a fully functional, decentralized blockchain with the same infrastructure as the main net. You use the testnet as a testing environment before you bring your code onto the main net. In contrast to the main net, Ether that lives on the Ropsten testnet has no value and can be easily mined on your own PC.

To make it easy you'll create a Docker container containing all tools you need. This allows you to work with the Ethereum blockchain from a JavaScript console.

What are we waiting for.. Let’s install the basics!

### 1. Install & run the environment 

### 2. Clone the git repository

Clone the git repository that contains a Docker container with geth & truffle into the directory **`deepdive-eth-101-base`**

    **git clone [https://github.com/deepdivetraining/geth-truffle-docker](https://github.com/deepdivetraining/geth-truffle-docker) deepdive-eth-101-base**

Now descend into the new directory

    cd deepdive-eth-101-base

## Start the docker containers

Now **start** the docker containers:

    docker-compose up -d

The client will start syncing a light version of the blockchain. This saves resources on your computer and limits the time required to download the blockchain. The **-d** (daemon) flag tells docker to start the processes in the background.

Next check the syncing progress by looking at the log files with the command:

    docker logs geth

<table>
  <tr><td><b>truffle:</b> fast Ethereum RPC client for testing and development</td></tr>
  <tr><td>light client: A Client that downloads only a small part of the blockchain.</td></tr>
</table>

In the first part of this workshop the go-ethereum client (**geth)** is used to access the blockchain. The geth client has been installed inside of the docker container.

## Login into the geth docker container

First create a command prompt in the docker container. **Open a new terminal window** and issue the following commands to access a command shell in the docker container:

    # Dive into the Docker container

    docker exec -it geth sh

## Lookup the accounts on RPC Testnet

    # Create a command prompt for accessing the rpc testnet # blockchain

    geth attach http://<your ip address>:8545

    # show the accounts that are available

    eth.accounts

    # check out the amount of Ether in the first account

    web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")

    # exit the command prompt

    exit

Note: Due to a bug in the docker environment, you need the IP address of your laptop for connecting to this testnet. You can check your ip address with the ifconfig (linux) or ipconfig (windows) command from a command prompt:

    ifconfig | grep "192."

## Show the latest block on Ropsten Testnet

    # Create a command prompt for accessing the ropsten testnet # blockchain

    geth attach http://localhost:8544

Test the installation by typing the following command on the geth command prompt:

    eth.getBlock('latest').number**

This should give the number of the most recent block on the Ropsten Ethereum Testnet. You can check this in the output of the first terminal window ("number" in the last output line) or through an Ethereum blockchain explorer ([http://ropsten.etherscan.io](http://ropsten.etherscan.io))

## Celebrate!

You are now all set to start experimenting with the Ethereum blockchain and smart contracts!
