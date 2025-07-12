#!/bin/sh
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &
[ ! -s ~/.config/mpd/pid ] && mpd && mpc pause # start mpd paused

st &
librewolf &

exec dwm
