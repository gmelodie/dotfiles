
# neovim
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim


# zsh
chsh -s $(which zsh)


# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mv zshrc ~/.zshrc
