
# zsh
chsh -s $(which zsh)
cp zshrc ~/.zshrc

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# neovim
mkdir ~/.config/nvim
cp init.vim ~/.config/nvim

