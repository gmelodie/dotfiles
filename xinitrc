#!/bin/sh
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &

xset r rate 200 40 # repeat delay (for backspace & other keys)

# start mpd paused
pgrep -x mpd >/dev/null || { mpd && mpc pause; }

firefox &
st &

# Disable X's built-in screen blanking and DPMS
xset s off            # disable screen saver
xset -dpms            # disable DPMS power saving
xset s noblank        # don't blank the video device
# run slock when idle for 10mins and no audio/video playing
xidlehook --not-when-fullscreen --not-when-audio --timer 600 '/usr/sbin/slock' '' &

exec dwm
