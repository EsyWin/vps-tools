#!/bin/bash
# install dependencies
apt -y install openssl build-essential git pkg-config libc6-dev m4 g++-multilib autoconf \
                   libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget \
                   libcurl4-openssl-dev bsdmainutils automake curl
# create user for wallet
useradd -m -d /home/whatcoin -s /bin/bash whatcoin
# login as user
su - whatcoin
# clone repo
git clone https://github.com/EsyWin/WhatCoin
# cd into
cd WhatCoin
# fetch params
./zcutil/fetch-params.sh;
# build
./zcutil/build.sh -j$(expr $(nproc) -1)
# create binary directory
mkdir ~/bin
# copy
cp src/verusd src/verus src/verus-tx ~/bin
strip ~/bin/what*
# create data dir
mkdir -p ~/.komodo/WHAT
cd ~/.komodo/WHAT
# download bootstrap
wget https://bootstrap.veruscoin.io/VRSC-bootstrap.tar.gz
tar xf VRSC-bootstrap.tar.gz
rm VRSC-bootstrap.tar.gz
# create secure rpcpassword
RPC_PASSWORD=$(openssl rand 60 | openssl base64 -A)
# create config file
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
rpcpassword=${RPC_PASSWORD}
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
seednode=185.25.48.236:27485
EOF;
verusd -daemon &
echo '#!/bin/bash\nOLDPWD="$(pwd)"\ncd /home/$USER/.komodo/WHAT\n/home/whatcoin/bin/verusd ${@}\ncd "${OLDPWD}' >  /home/$USER/bin/verusd;
echo '#!/bin/bash\n/home/whatcoin/bin/verus ${@}' > /home/$USER/bin/verus-cli;
chmod +x /home/$USER/bin/verus*;