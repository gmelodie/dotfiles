#!/bin/bash


RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"



function help() {
   echo "gmelodie's dotfiles install script"
   echo
   echo "usage: ./install.sh [Options]"
   echo "options:"
   echo "        -h       Print this help"
   echo "        -c       Only update configuration files"
   echo "        -v       Verbose"
   echo
}



function link_config_file() { # link_file(here, there)
    src=$1
    dst=$2

    if [ -e $dst ]
    then
        echo -e "\n${ORANGE}[Warning] Found existent $1, moving to $1.old${NC}"
        mv $dst $dst.old
    fi

    ln -sf $src $dst

    echo -e "${GREEN}Done${NC}"

}




# --------------------- Installing ------------------------
function install() {
    echo '############# Starting full system upgrade...'

    sudo apt -y update > /dev/null && sudo apt -y upgrade > /dev/null
    sudo apt install -y curl build-essential git python3 python3-neovim python3-virtualenvwrapper golang zsh universal-ctags gnome-terminal fzf nodejs tmux golang-go clang clangd fuse libfuse2 ripgrep
    sudo modprobe -v fuse

    # install meslo fonts
    mkdir -p ~/.fonts
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/.fonts/'MesloLGS NF Regular.ttf'
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/.fonts/'MesloLGS NF Bold.ttf'
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/.fonts/'MesloLGS NF Italic.ttf'
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/.fonts/'MesloLGS NF Bold Italic.ttf'

    echo 'Installing Rust...'
    curl https://sh.rustup.rs -sSf | sh
    rustup component add rust-analyzer # install LSP for Rust

    echo 'Installing keyd...'
    git clone https://github.com/rvaiya/keyd $HOME/Downloads/keyd
    cd $HOME/Downloads/keyd
    make && sudo make install
    sudo systemctl enable keyd && sudo systemctl start keyd
    cd $BASEDIR

    echo 'Installing espanso...'
    snap install espanso --classic

    echo 'Installing neovim appimage...'
    mkdir -p $HOME/.nvim 2>&1
    wget -O $HOME/.nvim/nvim.appimage "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" 2>&1
    chmod +x $HOME/.nvim/nvim.appimage 2>&1

    echo 'Installing xcreep...'
    if ! command -v go
    then
        echo "\n${RED}[Error] Golang not found, skipping xcreep installation${NC}"
    else
        go install github.com/gmelodie/xcreep@latest 2>&1
    fi

    echo 'Installing Oh my Zsh...'
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # change default shell to zsh
    # chsh -s $(which zsh)


    echo -e "${GREEN}Done${NC}"

} # --------------------- END Installing ------------------------




# --------------------- Configuring ------------------------
function config() {
    echo  '############# Installing configuration files...'

    echo -n 'Keyd configurations (keyd.conf)...'
    mkdir -p /etc/keyd/
    sudo ln -sf $BASEDIR/keyd.conf /etc/keyd/keyd.conf # cant use link_config_file because need sudo
    sudo systemctl restart keyd

    echo -n 'Neovim configurations (init.vim)...'
    mkdir -p $HOME/.config/nvim
    link_config_file $BASEDIR/init.vim $HOME/.config/nvim/init.vim
    link_config_file $BASEDIR/coc-settings.json $HOME/.config/nvim/coc-settings.json

    echo -n 'Espanso configurations (default.yml)...'
    mkdir -p $HOME/.config/espanso
    link_config_file $BASEDIR/espanso.yml $HOME/.config/espanso/default.yml

    echo -n 'Git configurations (.gitconfig)...'
    link_config_file $BASEDIR/gitconfig $HOME/.gitconfig

    echo -n 'Zsh configurations (.zshrc)...'
    link_config_file $BASEDIR/zshrc $HOME/.zshrc
    link_config_file $BASEDIR/p10k.zsh $HOME/.p10k.zsh

    echo -n 'Tmux configurations (.tmux.conf)...'
    link_config_file $BASEDIR/tmux.conf $HOME/.tmux.conf

    echo -n 'Alacritty configurations (alacritty.toml)...'
    mkdir -p $HOME/.config/alacritty
    link_config_file $BASEDIR/alacritty.toml $HOME/.config/alacritty/alacritty.toml

    echo -n 'Adding alacritty as terminal alternative (default)...'
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator `which alacritty` 50
    sudo update-alternatives --config x-terminal-emulator

    echo -n 'Loading gnome-terminal preferences...'
    if ! command -v gnome-terminal &> /dev/null
    then
        echo "\n${RED}[Error] gnome-terminal not found, skipping preferences installation${NC}"
    else
        cat $BASEDIR/gterminal.preferences | dconf load /org/gnome/terminal/legacy/profiles:/
        echo -e "${GREEN}Done${NC}"
    fi

    echo -n 'Copying desktop icons...'
    # Symlink application desktop icons
    ln -sf $BASEDIR/applications/* $HOME/.local/share/applications
    echo -e "${GREEN}Done${NC}"

} # --------------------- END Configuring ------------------------


while getopts ":hc" option; do
   case $option in
        h) # display Help
            help
            exit;;

        c) # configs-only
            config
            exit;;

        \?) # incorrect option
            echo "Error: Invalid option"
            exit;;
   esac
done



install
config


echo 'All done!'
echo -e "${GREEN}RUN THE FOLLOWING TO COMPLETE SETUP:${NC}"
echo "chsh -s \$(which zsh)"
echo 'Make sure to log out and back in so that changes can take place'


