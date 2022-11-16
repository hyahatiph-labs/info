#!/bin/bash
# Monero Canary bash script.
# Fetches the latest Monero block and hash.
# Creates canary file IAW dark.fail verification standards.
# Default is a locally running Monero node at localhost:18081
# Requires jq (e.g. apt,dnf...etc. install -y jq)
# Usage xmr-canary.sh DOMAIN NUM_DAYS

echo > xmr-canary.txt
# Fetch the latest tip n-1
echo Fetching latest Monero block height...
curl http://localhost:18081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' > xmr-height.txt
HEIGHT=$(echo "$(cat xmr-height.txt | jq .result.height) - 1" | bc)
# Fetch the hash of that height 
echo Fetching hash for $HEIGHT
curl http://localhost:18081/json_rpc -d "{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"get_block\",\"params\":{\"height\":$HEIGHT}" -H 'Content-Type: application/json' > xmr-hash.txt
HASH=$(echo "$(cat xmr-hash.txt | jq .result.block_header.hash)")
echo Latest hash: $HASH
# Create the text file
echo "I am the admin of $1." >> xmr-canary.txt
echo "I am in control of my PGP key." >> xmr-canary.txt
echo "I will update this canary within $2 days." >> xmr-canary.txt
echo "Today is $(echo $(date))." >> xmr-canary.txt
echo "" >> xmr-canary.txt
echo "Latest monero block hash ($HEIGHT):" >> xmr-canary.txt
echo $(echo $HASH | cut -d "\"" -f 2) >> xmr-canary.txt
# Sign
gpg --clear-sign xmr-canary.txt
cat xmr-canary.txt.asc
# Cleanup
rm xmr-canary.txt* xmr-height.txt xmr-hash.txt
