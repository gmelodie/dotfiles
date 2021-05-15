#!/bin/bash

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

# Copy repo to $HOME/.dotfiles
echo 'Installing dotfiles...'

# copy neovim configuration file
echo 'Installing Neovim configurations (init.vim)'
mkdir -p $HOME/.config/nvim

if [ -e $HOME/.config/nvim/init.vim ]
then
    echo '[Warning] Found existent init.vim, moving to init.vim.old'
    mv $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.old
fi

ln -sf $BASEDIR/init.vim $HOME/.config/nvim/init.vim


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


echo 'Installing Git configurations (.gitconfig)'
ln -sf $BASEDIR/gitconfig $HOME/.gitconfig


echo 'Installing xcreep'
if ! command -v go &> /dev/null
then
    echo "Golang not found, skipping xcreep installation"
else
    go get github.com/gmelodie/xcreep
fi

echo 'Loading gnome-terminal preferences'
if ! command -v gnome-terminal &> /dev/null
then
    echo "gnome-terminal not found, skipping preferences installation"
else
    cat $BASEDIR/gterminal.preferences | dconf load /org/gnome/terminal/legacy/profiles:/
fi

echo 'All done!'
echo 'Make sure to log out and back in so that changes can take place'


# Symlink application desktop icons
ln -sf $BASEDIR/applications/* $HOME/.local/share/applications
