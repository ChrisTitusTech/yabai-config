#!/bin/bash

sketchybar --add event space_change

sketchybar --add item yabai_dummy left \
  --set yabai_dummy display=0 \
  script="$PLUGIN_DIR/spaces.sh" \
  --subscribe yabai_dummy space_change

for sid in $(yabai -m query --spaces | jq -r '.[].index'); do
  display=$(yabai -m query --spaces --space $sid | jq -r '.display')
  
  sketchybar --add space space.$sid left \
    --set space.$sid space=$sid \
    icon=$sid \
    background.color=$TRANSPARENT \
    label.color=$ACCENT_COLOR \
    icon.color=$ACCENT_COLOR \
    display=$display \
    label.font="sketchybar-app-font:Regular:12.0" \
    icon.font="SF Pro:Semibold:12.0" \
    label.padding_right=10 \
    label.y_offset=-1 \
    click_script="$PLUGIN_DIR/space_click.sh $sid"

  # Build icon strip directly with single command  
  icon_strip=$(yabai -m query --windows --space $sid | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false) | .app' | awk '!seen[$0]++' | while read -r app; do
    printf " %s" "$($PLUGIN_DIR/icons.sh "$app")"
  done)
  
  if [ -z "$icon_strip" ]; then
    icon_strip=" —"
  fi

  sketchybar --set space.$sid label="$icon_strip"
done

# Highlight focused space
focused_space=$(yabai -m query --spaces | jq -r '.[] | select(.["has-focus"] == true) | .index')
if [ -n "$focused_space" ]; then
  sketchybar --set space.$focused_space background.drawing=on \
    background.color=$ACCENT_COLOR \
    label.color=$ITEM_COLOR \
    icon.color=$ITEM_COLOR
fi
