#!/bin/sh

xrdb -merge ~/.Xresources

feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &

xset r rate 200 40

# start mpd paused
pgrep -x mpd >/dev/null || { mpd && mpc pause; }

# Disable X blanking / DPMS
xset s off
xset -dpms
xset s noblank

# idle lock
xidlehook --not-when-fullscreen --not-when-audio \
  --timer 600 '/usr/sbin/slock' '' &

xsettingsd &

firefox &
signal-desktop &
discord &
st &

exec dwm

