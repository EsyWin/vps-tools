#!/bin/bash

### USER CONFIG ###

# prompt the user for username
echo 'Enter your desired username :'
# username prompt
read username
# prompt the user for password
echo 'Enter your desired password :'
# password prompt
read password
# create user from prompt
useradd -m $username
# assign password from prompt to passwd $username
{
    echo $password;
    echo $password;
} | passwd $username
# create admin group
groupadd admin
# add username from prompt to admin group
usermod -aG admin $username

### SSH CONFIG ###

# prompt
echo 'Enter your desired port to use SSH :'
read ssh_port
echo 'Type these commands from your desktop linux/mac to create & add yourself to SSH trusted users :'
echo '  ssh-keygen -b 4096 -t rsa'
echo '  ssh-copy-id -i ~/.ssh/id_rsa.pub username@remotePublicIPAddress'
# change ssh port
sed -i 's/#Port 22/Port $ssh_port/g' /etc/ssh/sshd_config
# disable root login
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
# disable password auth
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
# allow pubkey auth
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
# test config
sshd -t
# allow new ssh port
ufw allow $ssh_port
# restart ssh deamon
systemctl restart sshd
# notify user how to connect through SSH next time
echo 'use "ssh '$username@remotePublicIPAddress' -p $ssh_port" to connect to your VPS next time'

### FAIL2BAN CONFIG ###

apt install fail2ban -y
cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# fill our ssh ban config
cat << EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
#action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 3
bantime = 99999h
EOF
# start fail2ban
systemctl start fail2ban
# enablt fail2ban
systemctl enable fail2ban