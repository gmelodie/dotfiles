#!/bin/bash
set -x
export DISCORD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
export DISCORD_LATEST_FILE="$HOME/Downloads/newest-discord.deb"

wget -O $DISCORD_LATEST_FILE $DISCORD_URL -U "Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.0.1) Gecko/2008070206 Firefox/3.0.1" 
sudo dpkg -i $DISCORD_LATEST_FILE
sudo apt install -f
