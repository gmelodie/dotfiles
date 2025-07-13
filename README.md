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

