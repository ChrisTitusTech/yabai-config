#!/bin/sh

source "$CONFIG_DIR/colors.sh"

update_workspace_appearance() {
  sid=$1
  is_focused=$2

  if [ "$is_focused" = "true" ]; then
    sketchybar --set space.$sid background.drawing=on \
      background.color=$ACCENT_COLOR \
      label.color=$ITEM_COLOR \
      icon.color=$ITEM_COLOR
  else
    sketchybar --set space.$sid background.drawing=off \
      label.color=$ACCENT_COLOR \
      icon.color=$ACCENT_COLOR
  fi
}

update_icons() {
  sid=$1

  # Build icon strip directly with single command - filter out apps with no/blank titles
  icon_strip=$(yabai -m query --windows --space $sid | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false and .title != "" and .title != null and (.title | length) > 0 and (.title | test("^\\s*$") | not)) | .app' | awk '!seen[$0]++' | sort | while read -r app; do
    printf " %s" "$($CONFIG_DIR/plugins/icons.sh "$app")"
  done)
  
  if [ -z "$icon_strip" ]; then
    icon_strip=" —"
  fi

  sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
}

# Reset all space backgrounds first
for sid in $(yabai -m query --spaces | jq -r '.[].index'); do
  update_workspace_appearance "$sid" "false"
done

# Update focused space background
focused_space=$(yabai -m query --spaces | jq -r '.[] | select(.["has-focus"] == true) | .index')
if [ -n "$focused_space" ]; then
  update_workspace_appearance "$focused_space" "true"
fi

# Update icons for all visible spaces
for sid in $(yabai -m query --spaces | jq -r '.[] | select(.["is-visible"] == true) | .index'); do
  display=$(yabai -m query --spaces --space $sid | jq -r '.display')
  sketchybar --set space.$sid display=$display

  update_icons "$sid"
done
