#!/bin/sh
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -b &
dwmblocks &

# screen saving
xset s 600 600        # Screensaver blank after 600s (idle)
xset r rate 200 40 # repeat delay (for backspace)
xset +dpms            # Enable DPMS
xset dpms 600 600 600 # Standby, suspend, off after 600s
xidlehook --not-when-fullscreen --not-when-audio --timer 600 'slock' '' &


[ ! -s ~/.config/mpd/pid ] && mpd && mpc pause # start mpd paused

librewolf &
st &

exec dwm
