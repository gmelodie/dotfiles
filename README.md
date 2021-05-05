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
1. `curl`
2. `python3`
3. Neovim (download the [appimage](https://github.com/neovim/neovim/releases/latest) and put it in, `~/.nvim`)
4. `python3-neovim` (`python-pynvim` for arch)
5. [FUSE](https://github.com/AppImage/AppImageKit/wiki/FUSE) and `cmake` for neovim's appimage
6. [`zsh`](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
7. Golang
8. [`ctags`](https://ctags.io/)


## Installation
With all the requirements installed, simply run
`./install.sh`

Be sure to log out and log back into your account so that the changes in zsh can take place

## Common issues
- Make sure you log out and back in after changing the default shell to zsh (with the command `chsh` that is executed by default in the `install.sh` script)

- If you don't have `ctags` installed you might get this error: `Executable 'ctags' can't be found. Gutentags will be disabled. You can re-enable it by setting g:gutentags_enabled back to 1.`

- Depending on your systems's [`locale`](https://wiki.archlinux.org/index.php/Locale), mostly if it's not en-US, you may have some bugs with autocomplete and line breaks on `zsh`. In order to fix that (which will also change the language of your shell session to English), add `export LANG=en_US.UTF-8` to your `zshrc`. (*obs: this was already done in the current repo's zshrc file*)

- `[coc.nvim] "node" is not executable` usually means you don't have `nodejs` installed.

## Other configurations
- Terminal font: Hack Regular 12
- Terminal colors: Use the [gruvbox](https://github.com/morhetz/gruvbox) theme colors
- Using `gnome-terminal` opening a new tab is going to redirect you to the `~/` directory. In order to open the tabe in the same directory (i.e. `pwd`) you have to go to gnome-terminal > preferences > your profile > command and check `Run command as a login shell`.
- Install the `fzf` package (the `fzf` vim plugin will already be installed, but the package must be done manually).
- Install the [xcreep](https://github.com/gmelodie/xcreep) utility.
- Install [Obsidian](https://obsidian.md/) and `mv` it as `/home/gmelodie/applications/obsidian.appimage`.
- Clone the [vaults]() repo and add the following lines to `vaults/.git/config` in order to make git backup push without asking for a password:
```
[commit]
    gpgSign = false
```
