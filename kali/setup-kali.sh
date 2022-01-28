export USER=gmelodie

# New SSH keys
cd /etc/ssh/
mkdir default_kali_keys
mv ssh_host_* default_kali_keys/
dpkg-reconfigure openssh-server

# Change default SSH port
sed -i "s/\#Port\ 22/Port\ 1338/" sshd_config

# SSH rate limiting
apt install -y ufw
ufw limit 1338/tcp

# Add new user, delete kali
useradd -m $USER
usermod -a -G sudo $USER
su $USER
cp -R /home/kali /home/$USER
cd /home/$USER
git clone https://github.com/gmelodie/dotfiles
chown $USER:$USER /home/$USER/*
userdel -r kali

