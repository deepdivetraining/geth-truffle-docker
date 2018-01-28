# Copyright 2017 - Dechain User Group
FROM ethereum/client-go:stable

RUN mkdir -p -v /root/.ethereum/devchain/geth
# COPY static-nodes.json CustomGenesis.json pw /root/.ethereum/devchain/
COPY static-nodes.json /root/.ethereum/devchain/geth/
COPY pw /root/.ethereum/devchain/

# Create 2 accounts
RUN geth --datadir=/root/.ethereum/devchain account new --password /root/.ethereum/devchain/pw && \
    geth --datadir=/root/.ethereum/devchain account new --password /root/.ethereum/devchain/pw && \
    echo "***** Please backup this output below, it is your ethereum keys for the accounts *****" && \
    cat /root/.ethereum/devchain/keystore/*

# RUN geth --testnet --datadir /root/.ethereum/devchain init
#/root/.ethereum/devchain/CustomGenesis.json
