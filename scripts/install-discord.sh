#!/bin/bash
set -x
export DISCORD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
export DISCORD_LATEST_FILE="$HOME/Downloads/newest-discord.deb"

wget -O $DISCORD_LATEST_FILE $DISCORD_URL
sudo dpkg -i $DISCORD_LATEST_FILE
sudo apt install -f
