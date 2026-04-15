#!/usr/bin/env bash

# Oh-My-Zsh config

## vi-mode plugin - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode

export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true # Redraw prompt when switching input mode
export VI_MODE_SET_CURSOR=true                  # change cursor style when switching input mode

export MODE_INDICATOR="%F{blue}N%f" # Normal mode
export INSERT_MODE_INDICATOR="%F{green}I%f"

RPROMPT="\$(vi_mode_prompt_info)$RPROMPT" # Mode indicator in right prompt

### Cursor styles

# 0, 1 - Blinking block
# 2 - Solid block
# 3 - Blinking underline
# 4 - Solid underline
# 5 - Blinking line
# 6 - Solid line
export VI_MODE_CURSOR_NORMAL=0
export VI_MODE_CURSOR_VISUAL=2
export VI_MODE_CURSOR_INSERT=5
export VI_MODE_CURSOR_OPPEND=4
