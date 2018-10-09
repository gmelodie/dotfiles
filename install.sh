
# zsh
sed -e "s/USER/$USER/" zshrc > .zshrc # change USER for the current user
chsh -s $(which zsh)
mv .zshrc ~/.zshrc

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# neovim
mkdir ~/.config/nvim
cp init.vim ~/.config/nvim

