#!/bin/bash

sketchybar --add item front_app left \
  --set front_app background.color=$ACCENT_COLOR \
  icon.color=$ITEM_COLOR \
  label.color=$ITEM_COLOR \
  icon.font="sketchybar-app-font:Regular:14.0" \
  label.font="$LABEL_FONT" \
  background.drawing=on \
  background.corner_radius=10 \
  background.height=20 \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
