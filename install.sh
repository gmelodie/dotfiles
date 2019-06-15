
# copy neovim configuration file
mkdir -p ~/.config/nvim
rm ~/.config/nvim/init.vim
ln init.vim ~/.config/nvim/init.vim


# change default shell to zsh
chsh -s $(which zsh)


# install oh-my-zsh (zsh theme)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy zsh configuration file
rm ~/.zshrc
ln zshrc ~/.zshrc
