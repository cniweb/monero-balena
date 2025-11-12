#!/bin/bash

# Defaults if env vars are not set
if [ -z "$MINER_POOL" ]; then
      export MINER_POOL="rx-eu.unmineable.com:3333"
fi
if [ -z "$PASSWORD" ]; then
      export PASSWORD="x"
fi
if [ -z "$WALLET_ADDRESS" ]; then
      export WALLET_ADDRESS="LTC:ltc1q6c4vres6a390mtm4updr5jc6thyv22pu0dupq8.balena#Jumper"
fi

echo "Wallet Address: $WALLET_ADDRESS"
sleep 1

echo "Miner Pool: $MINER_POOL"
sleep 1

echo "Pool Password: $PASSWORD"
sleep 1

echo "Device Name: $RESIN_DEVICE_NAME_AT_INIT"
sleep 1

echo "Starting Monero Miner ......"
sleep 4

xmrig -o "$MINER_POOL" \
      -u "$WALLET_ADDRESS" \
      -p "$PASSWORD" \
      --donate-level=1
