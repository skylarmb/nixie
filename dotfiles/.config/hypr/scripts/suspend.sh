#!/usr/bin/env bash
swayidle -w \
timeout 300 'hyprlock' \
before-sleep 600 'hyprctl dispatch dpms off' \
resume 'hyprctl dispatch dpms on' \
before-sleep 'hyprlock'
