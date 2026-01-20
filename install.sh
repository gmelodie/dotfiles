#!/bin/bash

set -e # stop when a command fails

RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

MARTINHA=false

function help() {
   echo "gmelodie's dotfiles install script"
   echo
   echo "usage: ./install.sh [Options]"
   echo "options:"
   echo "        -h       Print this help"
   echo "        -c       Only update configuration files"
   echo "        -v       Verbose"
   echo "        -m       Martinha (includes keyd)"
   echo
}

function link_config() { # link_file(here, there)
    src=$1
    dst=$2

    if [ -e $dst ]; then
        echo -e "\n${ORANGE}[Warning] Found existing $dst, moving to $dst.old${NC}"
        mv $dst $dst.old
    fi

    ln -sf $src $dst
    echo -e "${GREEN}Done${NC}"
}

function install_debian() {
    echo '############# Starting full system upgrade (APT)...'
    sudo apt -y update > /dev/null && sudo apt -y upgrade > /dev/null
    sudo apt install -y curl build-essential git python3 python3-neovim golang zsh universal-ctags fzf nodejs golang-go clang clangd ripgrep snapd
}

function install_archlinux() {
    echo '############# Starting full system upgrade (Pacman)...'
    sudo pacman -Syyu
    sudo pacman -S wget curl base-devel git python python-pynvim python-pip python-pipx zsh fzf clang clang-analyzer ripgrep neovim mesa ly libx11 libxft xorg-server xorg-xinit xorg-xauth xorg-apps xorg-setxkbmap xdg-utils libnotify slock openssh feh picom imagemagick maim \
        pipewire pipewire-pulse pipewire-alsa pipewire-audio bc wireplumber alsa-utils alsa-firmware pavucontrol bluez bluez-utils bluez-deprecated-tools blueman playerctl mpd mpc rmpc \
        brightnessctl xclip wikiman arch-wiki-docs ranger nerd-fonts noto-fonts-emoji
    # bc is used for calculating int volume levels from floats

    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si
    yay -S librewolf-bin xidlehook

    # Enable services
    systemctl --user enable --now pipewire pipewire-pulse wireplumber
    sudo systemctl enable --now bluetooth ly
}

function post_install() {
    echo 'Installing Rust...'
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    rustup component add rust-analyzer

    if $MARTINHA; then
        echo 'Installing keyd...'
        git clone https://github.com/rvaiya/keyd $HOME/Downloads/keyd
        cd $HOME/Downloads/keyd
        make && sudo make install
        sudo systemctl enable keyd && sudo systemctl start keyd
        cd $BASEDIR
    fi

    echo 'Installing espanso...'
    if command -v snap &> /dev/null; then
        sudo snap install espanso --classic
    else
        mkdir -p ~/opt
        wget -O ~/opt/Espanso.AppImage 'https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-X11.AppImage'
        chmod u+x ~/opt/Espanso.AppImage
        sudo ~/opt/Espanso.AppImage env-path register
    fi
    sudo espanso service register

    echo 'Installing neovim appimage...'
    mkdir -p $HOME/.nvim
    wget -O $HOME/.nvim/nvim.appimage "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    chmod +x $HOME/.nvim/nvim.appimage

    echo 'Installing Oh My Zsh...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    echo -e "${GREEN}Done${NC}"
}

function config() {
    echo  '############# Installing configuration files...'

    if $MARTINHA; then
        echo 'Keyd configurations (keyd.conf)...'
        sudo mkdir -p /etc/keyd/
        sudo ln -sf $BASEDIR/keyd.conf /etc/keyd/keyd.conf
        sudo systemctl restart keyd

        echo 'X11 touchpad configurations (30-touchpad.conf)...'
        sudo mkdir -p /etc/X11/xorg.conf.d/
        sudo ln -sf $BASEDIR/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
    fi

    echo -n 'Neovim configurations (init.vim, etc.)...'
    mkdir -p $HOME/.config/nvim/lua/lsp
    ln -sf $BASEDIR/nvim/init.vim $HOME/.config/nvim/init.vim
    for file in $BASEDIR/nvim/lua/lsp/*; do
	filename=$(basename "$file")
	ln -sf $BASEDIR/nvim/lua/lsp/$filename $HOME/.config/nvim/lua/lsp/$filename
    done


    echo -n 'Espanso configurations (default.yml)...'
    mkdir -p $HOME/.config/espanso
    link_config $BASEDIR/espanso.yml $HOME/.config/espanso/default.yml

    echo -n 'Git configurations (.gitconfig)...'
    link_config $BASEDIR/gitconfig $HOME/.gitconfig

    echo -n 'Zsh configurations (.zshrc)...'
    link_config $BASEDIR/zshrc $HOME/.zshrc

    echo -n 'zprofile configurations...'
    link_config $BASEDIR/zprofile $HOME/.zprofile

    echo -n 'picom configurations...'
    link_config $BASEDIR/picom.conf $HOME/.config/picom.conf

    echo -n 'Tmux configurations (.tmux.conf)...'
    link_config $BASEDIR/tmux.conf $HOME/.tmux.conf

    echo -n 'xinitrc startup (dwm)...'
    link_config $BASEDIR/xinitrc $HOME/.xinitrc

    echo -n 'XCompose (for cedilha)...'
    link_config $BASEDIR/XCompose $HOME/.XCompose

    echo -n 'Xresources (for larger font sizes)...'
    link_config $BASEDIR/Xresources $HOME/.Xresources

    echo -n 'mpd config...'
    mkdir -p $HOME/.config/mpd
    mkdir -p $HOME/.config/mpd/playlists
    link_config $BASEDIR/mpd.conf $HOME/.config/mpd/mpd.conf

    echo -n 'rmpc config...'
    mkdir -p $HOME/.config/rmpc/themes
    link_config $BASEDIR/rmpc.ron $HOME/.config/rmpc/rmpc.ron
    link_config $BASEDIR/gmelodies-theme.ron $HOME/.config/rmpc/themes/gmelodies-theme.ron
}

function build_suckless() {
    echo -n 'Building dwm...'
    sudo make -C $BASEDIR/suckless/dwm clean install
    echo -n 'Building dmenu...'
    sudo make -C $BASEDIR/suckless/dmenu clean install
    echo -n 'Building dwmblocks...'
    sudo make -C $BASEDIR/suckless/dwmblocks clean install
    echo -n 'Building st...'
    sudo make -C $BASEDIR/suckless/st clean install
}


# -------------- Parse options ----------------
while getopts ":hcmv" option; do
    case $option in
        h)
            help
            exit;;
        c)
            config
            exit;;
        m)
            MARTINHA=true
            ;;
        \?)
            echo "Error: Invalid option"
            exit;;
    esac
done

# -------------- Start install ----------------
if grep -qi archlinux /etc/os-release; then
    install_archlinux
    build_suckless
else
    install_debian
fi

post_install

config

echo -e "${GREEN}All done!${NC}"
echo -e "${GREEN}RUN THE FOLLOWING TO COMPLETE SETUP:${NC}"
echo "chsh -s /usr/bin/zsh"
echo "Make sure to log out and back in so that changes can take place"

