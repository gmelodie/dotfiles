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

function install_archlinux() {
    echo '############# Starting full system upgrade (Pacman)...'
    sudo pacman -Syyu
    sudo pacman -S wget curl base-devel git python bat fd z python-pynvim python-pip python-pipx zsh fzf clang clang-analyzer ripgrep neovim mesa ly libx11 libxft xorg-server xorg-xinit xorg-xauth xorg-apps xorg-setxkbmap xdg-utils libnotify slock openssh feh picom imagemagick maim alacritty \
        pipewire pipewire-pulse pipewire-alsa pipewire-audio bc wireplumber alsa-utils alsa-firmware pavucontrol bluez bluez-utils bluez-deprecated-tools blueman playerctl mpd mpc rmpc \
        brightnessctl xclip xdotool wikiman arch-wiki-docs ranger nerd-fonts noto-fonts-emoji xsettingsd github-cli dunst
    # bc is used for calculating int volume levels from floats

    # yay-bin and its debug package both conflict with yay; drop whichever are installed
    conflicting=$(pacman -Qq yay-bin yay-bin-debug 2>/dev/null || true)
    [ -n "$conflicting" ] && sudo pacman -Rns --noconfirm $conflicting

    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si

    # stale clones in yay's cache break rebuilds when a package's source URL changes
    rm -rf "$HOME/.cache/yay/librewolf-bin" "$HOME/.cache/yay/xidlehook"

    # librewolf-bin's tarball is PGP-signed; makepkg aborts if the signing key is unknown
    gpg --keyserver keyserver.ubuntu.com --recv-keys 662E3CDD6FE329002D0CA5BB40339DD82B12EF16 ||
        echo -e "${ORANGE}Could not import the LibreWolf signing key; librewolf-bin may fail to build${NC}"

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
    mkdir -p ~/opt
    wget -O ~/opt/Espanso.AppImage 'https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-X11.AppImage'
    chmod u+x ~/opt/Espanso.AppImage
    sudo ~/opt/Espanso.AppImage env-path register
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

    echo -n 'ly display manager (config.ini + amber console palette)...'
    sudo mkdir -p /etc/ly/
    sudo ln -sf $BASEDIR/ly/config.ini /etc/ly/config.ini
    sudo ln -sf $BASEDIR/ly/amber-vtrgb /etc/ly/amber-vtrgb
    # The TTY is 16-color only, so amber comes from remapping the console
    # palette (setvtrgb) before ly draws — not from ly truecolor.
    sudo ln -sf $BASEDIR/systemd/console-amber.service /etc/systemd/system/console-amber.service
    sudo systemctl daemon-reload
    sudo systemctl enable --now console-amber.service
    echo -e "${GREEN}Done${NC}"

    if $MARTINHA; then
        echo 'Keyd configurations (keyd.conf)...'
        sudo mkdir -p /etc/keyd/
        sudo ln -sf $BASEDIR/keyd.conf /etc/keyd/keyd.conf
        sudo systemctl restart keyd

        echo 'X11 touchpad configurations (30-touchpad.conf)...'
        sudo mkdir -p /etc/X11/xorg.conf.d/
        sudo ln -sf $BASEDIR/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
    fi

    echo -n 'Neovim configurations (init.lua, etc.)...'
    mkdir -p $HOME/.config/nvim/lua/lsp
    rm -f $HOME/.config/nvim/init.vim
    ln -sf $BASEDIR/nvim/init.lua $HOME/.config/nvim/init.lua
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

    echo -n 'dunst configurations...'
    mkdir -p $HOME/.config/dunst
    link_config $BASEDIR/dunstrc $HOME/.config/dunst/dunstrc

    echo -n 'Tmux configurations (.tmux.conf)...'
    link_config $BASEDIR/tmux.conf $HOME/.tmux.conf

    echo -n 'xinitrc startup (dwm)...'
    link_config $BASEDIR/xinitrc $HOME/.xinitrc

    echo -n 'xprofile...'
    link_config $BASEDIR/xprofile $HOME/.xprofile

    echo -n 'XCompose (for cedilha)...'
    link_config $BASEDIR/XCompose $HOME/.XCompose

    echo -n 'Xresources (for larger font sizes)...'
    link_config $BASEDIR/Xresources $HOME/.Xresources

    echo -n 'Alacritty configurations (alacritty.toml)...'
    mkdir -p $HOME/.config/alacritty
    link_config $BASEDIR/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml

    echo -n 'xsettingsd (for gtx 2, 3 and 4)...'
    mkdir -p $HOME/.config/xsettingsd
    link_config $BASEDIR/xsettingsd $HOME/.config/xsettingsd/xsettingsd.conf

    echo -n 'mpd config...'
    mkdir -p $HOME/.config/mpd
    mkdir -p $HOME/.config/mpd/playlists
    link_config $BASEDIR/mpd.conf $HOME/.config/mpd/mpd.conf

    echo -n 'rmpc config...'
    mkdir -p $HOME/.config/rmpc/themes
    link_config $BASEDIR/rmpc.ron $HOME/.config/rmpc/rmpc.ron
    link_config $BASEDIR/gmelodies-theme.ron $HOME/.config/rmpc/themes/gmelodies-theme.ron

    echo -n 'WirePlumber Bluetooth speaker priority (51-bt-priority.conf)...'
    mkdir -p $HOME/.config/wireplumber/wireplumber.conf.d
    link_config $BASEDIR/wireplumber/51-bt-priority.conf $HOME/.config/wireplumber/wireplumber.conf.d/51-bt-priority.conf

    echo -n 'WirePlumber Bluetooth A2DP-only (52-bt-a2dp-only.conf)...'
    link_config $BASEDIR/wireplumber/52-bt-a2dp-only.conf $HOME/.config/wireplumber/wireplumber.conf.d/52-bt-a2dp-only.conf

    echo -n 'Bluetooth autoconnect + audio-routing service (bt-audio-autoconnect)...'
    mkdir -p $HOME/.config/systemd/user
    link_config $BASEDIR/systemd/bt-audio-autoconnect.service $HOME/.config/systemd/user/bt-audio-autoconnect.service
    systemctl --user daemon-reload
    systemctl --user enable --now bt-audio-autoconnect.service
    # scripts/bt-audio-autoconnect and scripts/bt-jota are already on PATH via zshrc

    echo 'BlueZ autoconnect policy (main.conf: AutoEnable + reconnect)...'
    sudo sed -i \
        -e 's/^#\?ReconnectAttempts=.*/ReconnectAttempts=7/' \
        -e 's/^#\?ReconnectIntervals=.*/ReconnectIntervals=1,2,4,8,16,32,64/' \
        -e 's/^#\?AutoEnable=.*/AutoEnable=true/' \
        /etc/bluetooth/main.conf
    sudo systemctl restart bluetooth
}

function build_suckless() {
    echo -n 'Building dwm...'
    sudo make -C $BASEDIR/suckless/dwm clean install
    echo -n 'Building dmenu...'
    sudo make -C $BASEDIR/suckless/dmenu clean install
    echo -n 'Building dwmblocks...'
    sudo make -C $BASEDIR/suckless/dwmblocks clean install
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
install_archlinux
build_suckless

post_install

config

echo -e "${GREEN}All done!${NC}"
echo -e "${GREEN}RUN THE FOLLOWING TO COMPLETE SETUP:${NC}"
echo "chsh -s /usr/bin/zsh"
echo "Make sure to log out and back in so that changes can take place"

