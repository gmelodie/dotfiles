#!/bin/sh
wal -i ~/Pictures/wallpaper.jpg
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &
[ ! -s ~/.config/mpd/pid ] && mpd

exec dwm
