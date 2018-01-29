# Ethereum environment with docker-compose + smart contract with truffle #

![devchain-infra.png](https://github.com/gregbkr/geth-truffle-docker/raw/master/media/devchain-infra.png)

## Description

This docker compose will give you in one command line:
- [**Ethereum go-client (geth)**](https://github.com/ethereum/go-ethereum/wiki/geth) running on port 8544 with
  - 2 ethereum accounts, already unlocked
  - Connected to Geneva devchain (network ID=2017042099)
  - Mining the blocks (optional)
  - Data are saved out of the container, on your host, so no problem if you delete the container
- [**Testrpc**](https://github.com/ethereumjs/testrpc): eth-node running a test network on port 8545
- [**Truffle**](https://github.com/ConsenSys/truffle): where you can test and deploy smart contracts
- [**Netstatsapi**](https://github.com/cubedro/eth-netstats): which will collect and send your node perf to our devchain dashboard on http://factory.shinit.net:15000
- [**Netstatsfront**](https://github.com/cubedro/eth-netstats): dashboard to display eth stats (not used by default, please uncomment in `docker-compose.yml` if needed and browse http://localhost:3000 )

More info: you can find an overview of that setup on my blog: https://greg.satoshi.tech/

## 0. Prerequisit
- A linux host, preferable ubuntu 14.x or 16.x. If you are on windows or MAC, please use [docker toolbox](#docker-toolbox) or [Vagrant](#vagrant) --> see in annexes
- [Docker](#docker) v17+ and [docker-compose](#docker-compose) v1.15+ 
- This code: `git clone https://github.com/deepdivetraining/geth-truffle-docker devchain && cd devchain`
- Create an environment var to declare your geth node name: `echo "export GETH_NODE=<YOUR_NODE_NAME>" >> ~/.profile && source ~/.profile`
- Check your node name: `echo $GETH_NODE`

## 1. Run containers

- Run the stack: `docker-compose up -d`
- Check geth is up and answering locally: `curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' localhost:8544 --header "Content-Type: application/json"`
- Check testrpc node is running: `curl -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' localhost:8545`
- Other rpc commands [here](https://github.com/ethereum/wiki/wiki/JSON-RPC#json-rpc-methods)

## 2. Geth
- Check container logs: `docker logs geth`
- Start shell in the geth container: `docker exec -it geth sh` 
- Interact with geth:
  - List account: `geth --datadir=/root/.ethereum/devchain account list` (other geth commands [here](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options))
  - To see your keys: `cat /root/.ethereum/devchain/keystore/*`
  - Backup the account somewhere safe. For example, I saved this block for my wallet (carefull, you can steal my coins with these infos):
```
{"address":"6e068b2fcf3ed73d5166d0b322fa10e784b7b4fe","crypto":{"cipher":"aes-128-ctr","ciphertext":"0d392da6deb66b13c95d1b723ea51a53ab58e1f7555c3a1263a5b203885b9e51","cipherparams":{"iv":"7a919e171cda132f375afd5f9e7c2ba1"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"1f3f814262b9a4ce3c2f3e1cabb5788f0520101f00598aa0b84bbda08ceaaf31"},"mac":"8e8393e86fe2278666ec26e9956b49adc25bc2e7492d5a25ee30e8118dd17441"},"id":"71aa2bfd-ee91-4206-ab5e-82c38ccd071f","version":3}/
```
  - The account is on your host too:
    - Exit docker `exit`
    - List docker volume: `docker volume ls`
    - See the physical location of your account: `docker volume inspect devchain_geth`
    - You can then browse the mount point `sudo ls /var/lib/docker/volumes/devchain_geth/_data/devchain`. From this location you can save or import another account (just copy/paste your key file)

- If needed, (**within** the geth container) create new account with:
  - Create password: `echo "Geneva2017" > /root/.ethereum/devchain/pw2`
  - create account: `geth --datadir=/root/.ethereum/devchain account new --password /root/.ethereum/devchain/pw2`

- Mining (y/n)? In `docker-compose.yml` section `geth/command` add/remove `--fast --mine` to the line `command` and run again `docker-compose up -d`

- Use python to check your node, and later send ether: 
  - Install python requirements: `sudo apt-get install -y python3 python3-pip && pip3 install web3`
  - Check your node: `python3 scripts/checkWeb3.py`
  - Want to send ether? Edit `remote`, `amountInEther` and comment `exit()`, and run the same script

- Check that you can see your node name on our netstats dashboard: http://factory.shinit.net:15000

![netstats.png](https://github.com/gregbkr/geth-truffle-docker/raw/master/media/netstats.png)


## 3. Truffle

#### 3.1 Description

Truffle will compile, test, deploy your smart contract. In `/dapp` folder, there are few examples of easy smart contracts. The addresses below are on the geneva devchain, feel free to play with it!

 ![robot-small.png](https://github.com/gregbkr/geth-truffle-docker/raw/dev/media/robot-small.png)

Definition of contracts running on devchain:

- **HelloWorld**: display a single message
  - Contract addr: `0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55`
  - Contract name: `Greeter`
  - Functions: 
    - `Greet()`: display the recorded message
    - `SetGreet()`: record a new message
  - Commands: 
    - `Greeter.at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55').Greet()`
    - `Greeter.at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55').SetGreet("My new message!")`
  - Abi:
```
[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"Greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"SetGreet","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"type":"constructor"}]
```

- **MetaCoin**: basic coin contract (default truffle contract you get when typing `truffle init`). Deployer's address gets 1000 coins
  - Contract addr: `0x718c8c6348b268d62c617cbd175703bd10b4f8fa`
  - Contract name: `MetaCoin`
  - Functions: 
    - `getBalance(addr)`: display balance in gwei
    - `getBalanceInEth(addr)`: display balance in ether
    - `sendCoin(addr, amount)`: sent coin to address
  - Command: `MetaCoin.at('0x718c8c6348b268d62c617cbd175703bd10b4f8fa').getBalance('0x99b77b612d43ba830d9db1eda0d0d23600db6874')`
  - Abi:
```
 [{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"getBalanceInEth","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"receiver","type":"address"},{"name":"amount","type":"uint256"}],"name":"sendCoin","outputs":[{"name":"sufficient","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"}]
```

- **Counter**: from 0, increment a simple counter, and see the result 
  - Contract addr: `0x44cd1f1fca0243f06f81238d039847855f3cf902`
  - Contract name: `Counter`
  - Functions: 
    - `increment()`: increment the counter each time you run
    - `getCount()`: see the result
  - Command: `Counter.at('0x44cd1f1fca0243f06f81238d039847855f3cf902').getCount()`
  - Abi: 
```
[{"constant":true,"inputs":[],"name":"getCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"increment","outputs":[],"payable":false,"type":"function"}]
```

As there are less test examples of test in solidity, I choose to create only  javascript test. These files `./test/*.js` will help you debug and strongly test your contract before to send it to production.

#### 3.2 Test our HelloWorld dapp in truffle
- Go in truffle container:  `docker exec -it truffle sh`
- Go to HelloWorld project: `cd /dapps/HelloWorld`
- Check configuration: `cat truffle.js` <-- it should map with `geth:8544` and `testrpc:8545`
- Check which value our contract will get at deployment : `cat migrations/2_deploy_contracts.js`, see: `I am Groot!`
- Test the contract against testrpc node: `truffle test --network testrpc`
- If warning message: `authentication needed: password or unlock` --> you need to unlock your wallet (should be unlock when starting geth normally)
  - `truffle console --network devchain`
  - `web3.personal.unlockAccount(web3.personal.listAccounts[0], "17Fusion", 150000);`
  - Exit with `Crtl+D`

#### 3.3 Send your HelloWorld contract devchain
While you can test and migrate your contract to testrpc, this environment only lives within your laptop. Next step is to deploy it to the devchain, so others will be able to access it.
- Send/migrate contract to devchain: `truffle migrate --network devchain` <-- you should get the contract address: `Greeter: 0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55` (add `--reset` if you want to redeploy an updated contract version)
- Check your last deployment: `truffle network`

#### 3.4 Interact with the contract from the truffle console:
- Access the console: `truffle console --network devchain` <-- Need to be in the right dapp folder to interact with contract
- See last Greeter contract deployed: `Greeter.deployed()` <-- Greeter is the declared name of the contract
- Greeter address: `Greeter.address`
- Run the `Greet()` function (the main one) of our contract: `Greeter.at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55').Greet()`
- We can map our contract to an object: `var contract = Greeter.at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55')`
- And simply call functions of this object: `contract.Greet()`

#### 3.5 Share your contract with others
For that you will need:
- The **contract address**: `0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55`
- The **abi**: a description of the functions of our contract 
  - From our host: install jq: `sudo apt-get install jq`
  - And display the abi: `cat dapp/HelloWorld/build/contracts/Greeter.json | jq -c '.abi'`
  - Result: 
```
[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"Greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"SetGreet","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"type":"constructor"}]
```
  - Go to a truffle's friend pc (or delete truffle container on your host `docker stop truffle; docker rm truffle` and start a new one `docker-compose up -d`), and interact with your contract:
  - Create the abi: 
```
abi=[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"Greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_greeting","type":"string"}],"name":"SetGreet","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"type":"constructor"}]
```
  - You can now run your contract function to see your custom message: `web3.eth.contract(abi).at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55').Greet()`

#### 3.6 New contract from template:
- Launch a new contract (a clone) from the template Greeter known locally by truffle: `var greeter2 = Greeter.new("Hello gva")`
- Get the address: `greeter2`
- Check the output of this new address: `Greeter.at('0x5c57d316f698ff2dc3e2bf1b5f2117e8b88b4c55').Greet()`

#### 3.7 Within truffle console, you can interact with your wallet:
- List accounts: `web3.eth.accounts`
- See account0 balance: `web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]).toNumber(),'ether')`  (could use `.toNumber()` for better display)
- Unlock your account: `web3.personal.unlockAccount(web3.personal.listAccounts[0], "17Fusion", 150000);`
- Send some ether: `web3.eth.sendTransaction({from:web3.personal.accounts[0], to:'0x41df2990b4efd225f2bc12dd8b6455bf1c07ff6d', value: web3.toWei(10, "ether")})`
- Send some ether between local account: `web3.eth.sendTransaction({from:web3.eth.accounts[0], to:web3.eth.accounts[1], value: web3.toWei(10, "ether") })`

#### 3.8 More in-deph exploration of the Lottery contract

- **Lottery**: Bet some ether, and get a winner
  - Contract addr: `Please deploy your own contract as it gets destroy when lottery finishes`
  - Contract name: `Lottery`
  - Functions: 
    - `bet()`: Send some ether with the transaction, in order to bet
    - `GetBetInEther(address)`: return how much an address bet
    - `GetUserAddress(int)`: return the address of the first/second better in the internal table/database
    - `testRandom()`: return the random number used in the lottery
    - `endLottery()`: only the contract owner can stop the lottery which should reveal the winner (game is just an example as it is not really fair)
  - Commands:
    - Deploy contract and truffle console to it
    - Create object lot: `lot=Lottery.at('your_contract_address')`
    - Return a simple var of the game: `lot.gameName()`
    - Bet from account0(bob): `lot.Bet({ from:web3.eth.accounts[0], value: web3.toWei(1, 'ether') })`
    - Bet from account1(alice): `lot.Bet({ from:web3.eth.accounts[1], value: web3.toWei(3, 'ether') })`
    - Check contract balance: `web3.fromWei(web3.eth.getBalance(lot.address).toNumber(),'ether')`
    - Check account0 balance: `web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]).toNumber(),'ether')`
    - Check total bet: `lot.totalBets().then( totalBets => console.log(totalBets.toNumber() ))`
    - Check bet of account0(bob): `lot.GetBetInEther.call(web3.eth.accounts[0]).then( bet => console.log( web3.fromWei(bet.toNumber(),'ether') ))`
    - Check address of first account: `lot.GetUserAddress.call('0').then( users => console.log( users ))`
    - Test the random number: `lot.test.call().then( num => console.log( num.toNumber() ))`
    - End the lottery (carefull here, contract's functions will be disabled after this last step): `lot.EndLottery({ from:web3.eth.accounts[0] }).then( winningNumber => console.log (winningNumber) )` --> Got an issue here returning the wining number

## 4. Front

## 4.1 Simple html page
We will talk to our contract on devchain via a simple html page.
- Html page is located here: `./front/helloworld.html`
- Make sure it target the right ethereum node: `HttpProvider("http://localhost:8544"))` for devchain
- The script section of the page need the web3 library `web3.min.js` that you can obtain via:
  - Online mapping: `<script type="text/javascript" src="https://rawgit.com/ethereum/web3.js/develop/dist/web3.min.js">`
  - Or from `ethereum/web3.js` github: `wget https://github.com/ethereum/web3.js/blob/develop/dist/web3.min.js` and link it with `<script src="./web3.min.js"></script>` 
  - Or node install: `cd ./front`, `npm init`, `npm install web3 --save`, `npm install ethereum/web3.js --save` then browse `ls ./node_modules/web3/dist/web3.min.js`
- Variable `abi` and `contract` should reference your contract abi and address
- Open then the page `./front/helloworld.html` with your favorite browser.


## Annexes

### Update images

To update Geth and truffle to the latest docker image, please rebuild the docker image, if a new image is present in dockerhub, it will get downloaded: `docker-compose up -d --build`

### Docker toolbox

- Toolbox will create in the backgroud a linux virtual machine (with virtualbox), and gives you an invite so you can run docker commands.
- Install [Docker toolbox](https://docs.docker.com/toolbox/overview/#whats-in-the-box) for windows or MAC.
- Check docker and compose version: `docker version` `docker-compose version`
- For windows, we will need to run all commands from the **Docker QuickStart shortcut** (troubleshooting guide [here](https://docs.docker.com/toolbox/toolbox_install_windows/#step-3-verify-your-installation) )

### Vagrant
- Install [Git](https://git-for-windows.github.io/) for windows or git for MAC
- Install the latest version of [vagrant](https://www.vagrantup.com/downloads.html) and [virtualbox](https://www.virtualbox.org/wiki/Downloads)
- Clone our repo and go at the root
- Create vagrant vm: `vagrant up`, and wait the vm to build
- Access the vm: `vagrant ssh`
- Access the files: `cd /vagrant/`
--> You are now in an ubuntu host, you can continue the tuto!

### Docker install on a linux box
- Install docker:
```
wget https://get.docker.com/ -O script.sh
chmod +x script.sh
sudo ./script.sh
sudo usermod -aG docker ${USER}
```
- check docker version: `docker version`

### Docker-compose install on a linux box
Replace 1.15.0 with latest version available on https://github.com/docker/compose/releases 
```
sudo -i
curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
exit
```
check docker-compose version `docker-compose version`
