#!/bin/bash

# nncreate.sh - script for creating a NOIA node with "one click" 
# version 190926-1

clear

echo
echo "Let's set up a NOIA node!"
echo
echo -n 'Your sudo password (not shown): '
read -s sudoPsw
echo
echo -n 'Your airdrop address: (Give null if none)'
read usrAirdropAddress
echo -n 'Enable NAT port mapping? (true/false): '
read usrNatPmp
echo -n 'Define shared storage size in megabytes: '
read usrSize

echo
echo "Check if these are correct:"
echo
echo "Airdrop address: $usrAirdropAddress"
echo "NAT port mapping: $usrNatPmp"
echo "Storage size (MB): $usrSize"
echo
echo "Hit Enter if OK, otherwise Ctrl+C:"
read paramsOk

usrSize=$(( 1024 * 1024 * $usrSize))

echo 2>/dev/null
echo '**** Installing NOIA node to '`hostname` 2>/dev/null
echo 2>/dev/null
echo '**** Installing obligatory modules...' 2>/dev/null
sleep 2 2>/dev/null
cd ~
echo $SUDOPWD |sudo -S apt -y update
sudo apt -y install curl git build-essential python-dev
echo 2>/dev/null

echo '**** Ensuring we have correct version of node.js installed...' 2>/dev/null
sleep 2 2>/dev/null
sudo apt -y remove nodejs
curl -sL https://deb.nodesource.com/setup_10.x | bash -
sudo apt -y install nodejs

echo '**** Fetching node-cli package...' 2>/dev/null
sleep 2 2>/dev/null
git clone https://github.com/noia-network/noia-node-cli.git

echo 2>/dev/null
echo '**** Installing npm...' 2>/dev/null
sleep 2 2>/dev/null
cd ~/noia-node-cli
sudo apt -y install npm
sudo npm install

echo '**** Fixing npm vulnerabilities, doing npm build...' 2>/dev/null
sleep 2 2>/dev/null
sudo npm audit fix
sudo npm run build

echo '**** Updating npm to the newest version...' 2>/dev/null
sleep 2 2>/dev/null
sudo npm install -g npm

echo 2>/dev/null
echo '**** Creating NOIA service and preparing the node. (Wait 15 sec)...' 2>/dev/null
sleep 2 2>/dev/null
cd ~
NUSER=`users`
NHOME=`pwd`
echo '[Unit]
Description=noia
[Service]
User='$NUSER'
WorkingDirectory='$NHOME'/noia-node-cli
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=7
[Install]
WantedBy=default.target' > noia.service
sudo cp noia.service /etc/systemd/system/noia.service
sudo systemctl enable noia.service
sudo systemctl start noia.service

sleep 15 2>/dev/null

echo "Stopping the node and editing the node settings..." 2>/dev/null
sudo systemctl stop noia.service
echo 2>/dev/null
echo "Setting airdrop address to $usrAirdropAddress" 2>/dev/null
sed -i "s/airdropAddress=.*/airdropAddress=$usrAirdropAddress/g" .noia-node/node.settings
echo "Setting natPmp to $usrNatPmp" 2>/dev/null
sed -i "s/natPmp=.*/natPmp=$usrNatPmp/g" .noia-node/node.settings
echo "Setting storage size to $usrSize" 2>/dev/null
sed -i "s/size=.*/size=$usrSize/g" .noia-node/node.settings
echo 2>/dev/null
echo "Restarting the node service" 2>/dev/null
sudo systemctl start noia.service

echo 2>/dev/null
echo '**** Done! Now check the node status with command:' 2>/dev/null
echo '**** sudo journalctl -fu noia.service' 2>/dev/null
echo '**** Exit with Ctrl+C' 2>/dev/null
echo 2>/dev/null
