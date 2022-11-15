echo "     _    _         _                   _____ _           _           "
echo "    / \  (_)_ __ __| |_ __ ___  _ __   |  ___(_)_ __   __| | ___ _ __ "
echo "   / _ \ | | '__/ _\` | '__/ _ \| '_ \  | |_  | | '_ \ / _\` |/ _ \ '__|"
echo "  / ___ \| | | | (_| | | | (_) | |_) | |  _| | | | | | (_| |  __/ |   "
echo " /_/   \_\_|_|  \__,_|_|  \___/| .__/  |_|   |_|_| |_|\__,_|\___|_|   "
echo "                               |_|                                    "

echo "Website  : https://www.airdropfinder.com"
echo "Telegram : https://t.me/airdropfind"
echo "Facebook : https://www.facebook.com/groups/744001332439290"
echo "Twitter  : https://twitter.com/AirdropfindX"
sleep 5

echo "==========INSTALLING DEPENDENCIES=========="
sleep 2
sudo apt-get update
sudo apt-get install -y make gcc git wget curl screen

echo "==========INSTALLING GOLANG=========="
sleep 2

wget https://go.dev/dl/go1.19.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
echo "Go version:"
go version
rm go1.19.3.linux-amd64.tar.gz


echo "==========INSTALLING GITOPIA=========="
sleep 2

curl https://get.gitopia.com | sudo bash
git clone -b v1.2.0 gitopia://gitopia/gitopia
cd gitopia && make install
sudo cp $HOME/go/bin/gitopiad /usr/bin/gitopiad

echo "Check gitopiad version:"
gitopiad version --long
rm .gitopia/config/genesis.json
if [ ! $GITOPIA_MONIKER ]; then
read -p "Enter node name: " GITOPIA_MONIKER
echo 'export GITOPIA_MONIKER='\"${GITOPIA_MONIKER}\" >> $HOME/.bash_profile
fi
echo "export GITOPIA_WALLET=wallet" >> $HOME/.bash_profile
echo "export GITOPIA_CHAIN_ID="gitopia-janus-testnet-2"" >> $HOME/.bash_profile
source $HOME/.bash_profile
gitopiad init --chain-id "$GITOPIA_CHAIN_ID" "$GITOPIA_MONIKER"

wget https://server.gitopia.com/raw/gitopia/testnets/master/gitopia-janus-testnet-2/genesis.json.gz
gunzip genesis.json.gz
mv genesis.json $HOME/.gitopia/config/genesis.json
gitopiad validate-genesis
sed -i 's#seeds = ""#seeds = "399d4e19186577b04c23296c4f7ecc53e61080cb@seed.gitopia.com:26656"#' $HOME/.gitopia/config/config.toml

echo "==========MENJALANKAN NODE=========="
sleep 2
gitopiad start
