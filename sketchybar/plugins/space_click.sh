#!/bin/sh

apps=$(yabai -m query --windows --space $1 | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false) | .app')
focused=$(yabai -m query --spaces | jq -r '.[] | select(.["has-focus"] == true) | .index')

if [ "${apps}" = "" ] && [ "${focused}" != "$1" ]; then
  sketchybar --set space.$1 display=0
else
  yabai -m space --focus $1
fi
