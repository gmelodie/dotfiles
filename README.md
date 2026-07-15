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

## Bluetooth audio
`./install.sh` deploys the WirePlumber configs and the autoconnect service. To
set it up (or repair it) by hand:
```bash
# WirePlumber configs (A2DP-only + speaker priority)
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
ln -sf "$PWD/wireplumber/51-bt-priority.conf"  ~/.config/wireplumber/wireplumber.conf.d/
ln -sf "$PWD/wireplumber/52-bt-a2dp-only.conf" ~/.config/wireplumber/wireplumber.conf.d/
systemctl --user restart wireplumber

# Autoconnect + audio-routing service (keeps the preferred speaker connected)
mkdir -p ~/.config/systemd/user
ln -sf "$PWD/systemd/bt-audio-autoconnect.service" ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now bt-audio-autoconnect.service
```
If a headset connects but plays no audio, disconnect/reconnect it once so it
renegotiates on A2DP (`bluetoothctl disconnect <MAC>; bluetoothctl connect <MAC>`).

