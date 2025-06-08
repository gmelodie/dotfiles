mkdir -p $HOME/.nvim 2>&1

url=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep browser | grep x86 | grep appimage | grep -v zsync | cut -d '"' -f 4)

curl -L "$url" -o "$HOME/.nvim/nvim.appimage"

chmod +x $HOME/.nvim/nvim.appimage 2>&1













