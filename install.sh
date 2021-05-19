#!/bin/bash

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"


# Install dependencies (requires apt)
sudo apt -y update && sudo apt -y upgrade
sudo apt install curl build-essential git python3 python3-neovim python3-virtualenvwrapper golang zsh exuberant-ctags gnome-terminal fzf nodejs dconf


echo 'Installing dotfiles...'

# --------------------- NVIM ------------------------
echo 'Installing Neovim configurations (appimage, init.vim)'
mkdir -p $HOME/.nvim
wget -O $HOME/.nvim/nvim.appimage "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
chmod +x $HOME/.nvim/nvim.appimage

mkdir -p $HOME/.config/nvim
if [ -e $HOME/.config/nvim/init.vim ]
then
    echo '[Warning] Found existent init.vim, moving to init.vim.old'
    mv $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.old
fi

ln -sf $BASEDIR/init.vim $HOME/.config/nvim/init.vim



# --------------------- SSH and GPG ------------------------
echo 'Generating SSH and GPG keys'
$BASEDIR/gen-ssh-gpg-keys.sh

# --------------------- GIT ------------------------
echo 'Installing Git configurations (.gitconfig)'
ln -sf $BASEDIR/gitconfig $HOME/.gitconfig


# --------------------- XCREEP ------------------------
echo 'Installing xcreep'
if ! command -v go &> /dev/null
then
    echo "[Error] Golang not found, skipping xcreep installation"
else
    go get github.com/gmelodie/xcreep
fi

# --------------------- GNOME PREFERENCES ------------------------
echo 'Loading gnome-terminal preferences'
if ! command -v gnome-terminal &> /dev/null
then
    echo "[Error] gnome-terminal not found, skipping preferences installation"
else
    cat $BASEDIR/gterminal.preferences | dconf load /org/gnome/terminal/legacy/profiles:/
fi

# --------------------- ZSH ------------------------
echo 'Installing Zsh configurations (zshrc)'

# change default shell to zsh
chsh -s $(which zsh)

# install oh-my-zsh (zsh theme)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy zsh configuration file
if [ -e $HOME/.zshrc ]
then
    echo '[Warning] Found existent zshrc, moving to zshrc.old'
    mv $HOME/.zshrc $HOME/zshrc.old
fi

ln -sf $BASEDIR/zshrc $HOME/.zshrc


# --------------------- DESKTOP ICONS ------------------------
# Symlink application desktop icons
ln -sf $BASEDIR/applications/* $HOME/.local/share/applications


echo 'All done!'
echo 'Make sure to log out and back in so that changes can take place'


