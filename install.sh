
# neovim
if [ ! -d "~/.config" ]
then
    mkdir ~/.config
fi

mkdir ~/.config/nvim
cp init.vim ~/.config/nvim


# zsh
sed -e "s/USER/$USER/" zshrc > zshrc-temp # change USER for the current user
chsh -s $(which zsh)
mv zshrc-temp ~/.zshrc


# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

