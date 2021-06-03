#!/bin/bash

RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

echo -n 'Starting full system update...'

# Install dependencies (requires apt)
sudo apt -y update > /dev/null 2>&1 && sudo apt -y upgrade > /dev/null 2>&1
sudo apt install curl build-essential git python3 python3-neovim python3-virtualenvwrapper golang zsh exuberant-ctags gnome-terminal fzf nodejs dconf > /dev/null 2>&1
snap install espanso --classic

echo -e "${GREEN}Done${NC}"


# --------------------- NVIM ------------------------
echo -n 'Installing Neovim configurations (appimage, init.vim)...'
mkdir -p $HOME/.nvim > /dev/null 2>&1
wget -O $HOME/.nvim/nvim.appimage "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" > /dev/null 2>&1
chmod +x $HOME/.nvim/nvim.appimage > /dev/null 2>&1

mkdir -p $HOME/.config/nvim
if [ -e $HOME/.config/nvim/init.vim ]
then
    echo -e "\n${ORANGE}[Warning] Found existent init.vim, moving to init.vim.old${NC}"
    mv $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.old
fi

ln -sf $BASEDIR/init.vim $HOME/.config/nvim/init.vim

echo -e "${GREEN}Done${NC}"


# --------------------- Espanso ------------------------
echo -n 'Installing Espanso configurations (default.yml)'
mkdir -p $HOME/.config/espanso
if [ -e $HOME/.config/espanso/default.yml ]
then
    echo -e "\n${ORANGE}[Warning] Found existent default.yml, moving to default.yml.old${NC}"
    mv $HOME/.config/espanso/default.yml $HOME/.config/espanso/default.yml.old
fi

ln -sf $BASEDIR/espanso.yml $HOME/.config/espanso/user/espanso.yml
echo -e "${GREEN}Done${NC}"



# --------------------- SSH and GPG ------------------------
echo 'Generating SSH and GPG keys'
$BASEDIR/gen-ssh-gpg-keys.sh

# --------------------- GIT ------------------------
echo -n 'Installing Git configurations (.gitconfig)...'
ln -sf $BASEDIR/gitconfig $HOME/.gitconfig
echo -e "${GREEN}Done${NC}"


# --------------------- XCREEP ------------------------
echo -n 'Installing xcreep...'
if ! command -v go &> /dev/null 2>&1
then
    echo "\n${RED}[Error] Golang not found, skipping xcreep installation${NC}"
else
    go get github.com/gmelodie/xcreep > /dev/null 2>&1
    echo -e "${GREEN}Done${NC}"
fi

# --------------------- GNOME PREFERENCES ------------------------
echo -n 'Loading gnome-terminal preferences...'
if ! command -v gnome-terminal &> /dev/null
then
    echo "\n${RED}[Error] gnome-terminal not found, skipping preferences installation${NC}"
else
    cat $BASEDIR/gterminal.preferences | dconf load /org/gnome/terminal/legacy/profiles:/
    echo -e "${GREEN}Done${NC}"
fi

# --------------------- DESKTOP ICONS ------------------------
# Symlink application desktop icons
ln -sf $BASEDIR/applications/* $HOME/.local/share/applications


# --------------------- GIT REMOTE HTTPS -> SSH  ------------------------
echo -n 'Changing dotfiles remote from HTTPS to SSH...'
git remote set-url origin git@github.com:gmelodie/dotfiles.git
echo -e "${GREEN}Done${NC}"


# --------------------- ZSH ------------------------
echo 'Installing Zsh configurations (zshrc)'

# change default shell to zsh
chsh -s $(which zsh)

# install oh-my-zsh (zsh theme)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy zsh configuration file
if [ -e $HOME/.zshrc ]
then
    echo -e "\n${ORANGE}[Warning] Found existent zshrc, moving to zshrc.old${NC}"
    mv $HOME/.zshrc $HOME/zshrc.old
fi

ln -sf $BASEDIR/zshrc $HOME/.zshrc

# copy p10k configuration file
if [ -e $HOME/.p10k.zsh ]
then
    echo -e "\n${ORANGE}[Warning] Found existent p10k.zsh, moving to p10k.zsh.old${NC}"
    mv $HOME/.p10k.zsh $HOME/p10k.zsh.old
fi

ln -sf $BASEDIR/p10k.zsh $HOME/.p10k.zsh


echo 'All done!'
echo 'Make sure to log out and back in so that changes can take place'


