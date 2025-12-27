#!/bin/bash

# Use env var passed by aerospace (faster), fallback to command if not set
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Get workspaces with windows
OCCUPIED=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)

# Build a single batched sketchybar command
ARGS=()

for sid in 1 2 3 4 5 6 7 8 9; do
    if echo "$OCCUPIED" | grep -q "^${sid}$"; then
        # Show workspace (has windows)
        if [ "$FOCUSED" = "$sid" ]; then
            ARGS+=(--set space.$sid drawing=on icon.color=0xffffffff)
        else
            ARGS+=(--set space.$sid drawing=on icon.color=0xff666666)
        fi
    else
        # Hide empty workspace (unless focused)
        if [ "$FOCUSED" = "$sid" ]; then
            ARGS+=(--set space.$sid drawing=on icon.color=0xffffffff)
        else
            ARGS+=(--set space.$sid drawing=off)
        fi
    fi
done

# Single atomic update to sketchybar with animation context
sketchybar --animate linear 0 "${ARGS[@]}"
