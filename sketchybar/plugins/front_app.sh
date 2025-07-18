#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

app_switched() {
  # Get the title of the focused window
  title=$(yabai -m query --windows | jq -r '.[] | select(.["has-focus"] == true) | .title')
  
  # Update all visible spaces with their actual windows
  for sid in $(yabai -m query --spaces | jq -r '.[] | select(.["is-visible"] == true) | .index'); do
    # Build icon strip from actual windows in the space only
    icon_strip=$(yabai -m query --windows --space $sid \
    | jq -r '.[] | select(.["is-minimized"] == false and .["is-hidden"] == false and .title != "" and .title != null and (.title | length) > 0 and (.title | test("^\\s*$") | not)) | .app' \
    | sort -u | while read -r app; do
      printf " %s" "$($CONFIG_DIR/plugins/icons.sh "$app")"
    done)
    
    if [ -z "$icon_strip" ]; then
      icon_strip=" —"
    fi

    sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
  done
  
  # Update front app with icon and title
  sketchybar --set $NAME label="$title"
}

if [ "$SENDER" = "front_app_switched" ]; then
  app_switched
fi
