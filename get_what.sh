#!/bin/bash
# install dependencies
sudo apt-get install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git zlib1g-dev wget bsdmainutils automake curl
# create user for wallet
useradd -m -d /home/veruscoin -s /bin/bash veruscoin
# login as user
{
git clone https://github.com/EsyWin/WhatCoin;
cd WhatCoin;
./zcutil/fetch-params.sh;
./zcutil/build.sh -j$(expr $(nproc) -1);
mkdir ~/bin;
cp src/whatd src/what src/what-tx ~/bin;
strip ~/bin/what*;
mkdir -p ~/.komodo/WHAT;
cd ~/.komodo/WHAT;

cat << EOF >  ~/.komodo/WHAT/WHAT.conf
server=1
listen=1
listenonion=0
maxconnections=256

# logging related options
logtimestamps=1
logips=1
shrinkdebugfile=0

# how many blocks to check on startup
checkblocks=64

# indexing options
txindex=1
addressindex=1
timestampindex=1
spentindex=1

# make sure ipv4 & ipv6 is used
bind=0.0.0.0
bind=::

# rpc settings
rpcuser=whatcoin
rpcpassword=
rpcport=31337
rpcthreads=256
rpcworkqueue=1024
rpcbind=127.0.0.1
rpcallowip=127.0.0.1

# if a peer jacks up more than 25 times in a row, ban it
banscore=25

# stake if possible, although it's probably not helping much
mint=1

# addnodes
seednode=185.25.48.236:27485
EOF;
whatd -daemon &;
echo '#!/bin/bash\nOLDPWD="$(pwd)"\ncd /home/$USER/.komodo/WHAT\n/home/whatcoin/bin/whatd ${@}\ncd "${OLDPWD}' >  /home/$USER/bin/whatcoind;
echo '#!/bin/bash\n/home/whatcoin/bin/verus ${@}' > /home/$USER/bin/whatcoin-cli;
chmod +x /home/$USER/bin/whatcoin*;
} | su - veruscoin
