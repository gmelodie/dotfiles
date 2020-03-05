# dotfiles
Configuration files automation

If you ever had to format your PC more than twice in a week you know that configuring everything is painful.
But even if you aren't insane enough to format your PC once every hour, you probably spend a couple of hours
configuring it after formating.
What I tried to do is assemble a list of my dotfiles (configuration files) and write a script that copies
and pastes everything into place. 

## Currently supported applications
* Neovim
* Zsh

## Requirements
1. Curl
2. Python3
3. Neovim (download the [appimage](https://github.com/neovim/neovim/releases/latest) and put it in, `~/.nvim`)
4. Python3-neovim (`python-pynvim` for arch)
5. FUSE and Cmake for neovim's appimage
6. Zsh
7. Golang


## Installation
With all the requirements installed, simply run
`./install.sh`

Be sure to log out and log back into your account so that the changes in zsh can take place

## Common issues
1. Make sure you log out and back in after changing the default shell to zsh (with the command `chsh` that is executed by default in the `install.sh` script)

2. The `YouCompleteMe` plugin for Neovim currently throws an error after installing (`"The ycmd server SHUT DOWN (restart with :YcmRestartServer)"`). To fix this simply (1) make sure you have python3 installed and (2) execute the `install.py` script located in `.config/nvim/plugged/youcompleteme/` (this path may change depending on where your nvim configs are located): `python3 install.py` or `./install.py`

3. Depending on your systems's [`locale`](https://wiki.archlinux.org/index.php/Locale), mostly if it's not en-US, you may have some bugs with autocomplete and line breaks on `zsh`. In order to fix that (which will also change the language of your shell session to English), add `export LANG=en_US.UTF-8` to your `zshrc`. (*obs: this was already done in the current repo's zshrc file*)

## Other configurations
- Terminal font: Hack Regular 12
