#!/bin/bash

current_brightness=$(brightnessctl -d '*::kbd_backlight' get)

max_brightness=$(brightnessctl -d '*::kbd_backlight' max)

# 25% of max brightness (low light)
low_brightness=$((max_brightness / 4))

# Toggle backlight between 0, low, and max
if [ "$current_brightness" -eq 0 ]; then
    brightnessctl -d '*::kbd_backlight' set "$low_brightness"
elif [ "$current_brightness" -eq "$low_brightness" ]; then
    brightnessctl -d '*::kbd_backlight' set "$max_brightness"
else
    brightnessctl -d '*::kbd_backlight' set 0
fi

