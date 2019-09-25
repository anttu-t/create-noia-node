# create-noia-node
Script for creating a NOIA Linux command line node on a VPS

This script creates automativcally a NOIA node on a Linux VPS, asking first certain parameters to be used.

Installing the script
--------------------------

Install the script by giving commands:

cd ~
curl -LO blablabla
sudo chmod u+x nncreate.sh

Using the script
----------------

Start the script with command (in your home directory):

./nncreate.sh

In the beginning some parameters are asked:

- sudo password - give here the password you use for sudo commands
- airdrop address - use here the wallet address you have registered to NOIA, or null if not used
- enable NAT port mapping - If your router supports NATPMP protocol, type true, otherwise type false
- define storage size - this is the disk space reserved for caching, currently 100 is good value here

After verifying the values, the script installs required modules and NOIA software. 
It also edits automatically the settings file (~/.noia-node/node.settings) and starts the service.
