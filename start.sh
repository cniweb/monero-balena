#!/bin/bash

echo "Wallet Address: $WALLET_ADDRESS"
sleep 1

echo "Miner Pool: $MINER_POOL"
sleep 1

echo "Device Name: $PASSWORD"
sleep 1

echo "Starting Monero Miner ......"
sleep 4

xmrig -o $MINER_POOL \
      -u $WALLET_ADDRESS \
      -p $PASSWORD
