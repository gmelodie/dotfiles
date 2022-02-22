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
* Gnome Terminal

## Requirements
Installed by default, check `install.sh` for a list of installed modules.

## Installation
With all the requirements installed, simply run
```bash
./install.sh
```

Only update configuration files
```bash
./install.sh -c
```

Print usage help
```bash
./install.sh -h
```

Be sure to log out and log back into your account so that the changes in zsh can take place

## Notes for developers (or myself)
- To save `gnome-terminal` preferences use `dconf dump /org/gnome/terminal:/ > gterminal.preferences` ([reference](https://askubuntu.com/a/1241849/855527))

## Common issues
- Make sure you log out and back in after changing the default shell to zsh (with the command `chsh` that is executed by default in the `install.sh` script)

- If you don't have `exuberant-ctags` installed you might get this error: `Executable 'ctags' can't be found. Gutentags will be disabled. You can re-enable it by setting g:gutentags_enabled back to 1.`

- Depending on your systems's [`locale`](https://wiki.archlinux.org/index.php/Locale), mostly if it's not en-US, you may have some bugs with autocomplete and line breaks on `zsh`. In order to fix that (which will also change the language of your shell session to English), add `export LANG=en_US.UTF-8` to your `zshrc`. (*obs: this was already done in the current repo's zshrc file*)

- `[coc.nvim] "node" is not executable` usually means you don't have `nodejs` installed.

- `curl -sL install-node.vercel.app/lts | bash` just do `curl -sL install-node.vercel.app/lts | bash` (from [here](https://github.com/neoclide/coc.nvim))

## Manual configurations
- KDE Desktop switching: `System settings` > `Workspace` > `Shortcuts` > `Kwin` and reassign "Switch to Next Desktop" to `Meta` + `Tab`
- Terminal font: Hack Regular 12
- Terminal colors: Use the [gruvbox](https://github.com/morhetz/gruvbox) theme colors
- Using `gnome-terminal` opening a new tab is going to redirect you to the `~/` directory. In order to open the tabe in the same directory (i.e. `pwd`) you have to go to gnome-terminal > preferences > your profile > command and check `Run command as a login shell`.
- `Settings` > `Keyboard Shortcuts` > `Switch to next input source` and set it to `Ctrl+Alt+K`
- Add two keyboard layouts: Install the `Portuguese` language packages, then set the keyboard layouts to `English(US)` and `English(US, alt., intl.)`
- Install [Obsidian](https://obsidian.md/) and `mv` it as `/home/gmelodie/applications/obsidian.appimage`.
- Clone the [vaults]() repo and add the following lines to `vaults/.git/config` in order to make git backup push without asking for a password:
```
[commit]
    gpgSign = false
```

## Kali configs
- PT keyboard layout is `Portuguese (Brasil) Nativo for US keyboards`
- Create new sudo user (`sudo useradd -m new_user`, `sudo usermod -aG sudo new_user`) and delete `kali` user (`sudo userdel kali` and `sudo rm -rf /home/kali`)
- Install `ufw` and enable it denying all ports by default (`sudo ufw default deny incoming` and `sudo ufw enable`) -> limit SSH if applicable
