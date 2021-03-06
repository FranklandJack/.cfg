# Sets up prompt, to be sourced in .zshrc at startup.
# Widgets for displaying mode when using vim mode.
autoload -Uz promptinit && promptinit

# Prompt string is subject to expansion before it is drawn.
setopt prompt_subst

# For color formatting.
autoload -Uz colors && colors

# Useful strings to put in prompt.
# Not all of these are used but I can easily swap to them if I want to.
CYAN="%B%F{cyan}"
RED="%B%F{red}"
YELLOW="%B%F{yellow}"
WHITE="%B%F{white}"
GREEN="%B%F{green}"
GREY="%B%F{grey}"
MAG="%B%F{magenta}"
BLUE="%B%F{blue}"
# This is the color that indicates whether in VI mode.
CURRENT_COLOR=${GREEN}
RESET_COLOR="%b%f"

OPEN_BRA="${CYAN}[% ${RESET_COLOR}"
CLOSE_BRA="${CYAN}]% ${RESET_COLOR}"

TIME="0"
TIMER='${OPEN_BRA}${RED}${TIME}${RESET_COLOR}${CLOSE_BRA}'
USER_NAME="${RED}%n${RESET_COLOR}"
WORK_DIR="${MAG}%1d${RESET_COLOR}"
# This value changes color based on the current mode.
PRIVLIGE='${CURRENT_COLOR}%#${RESET_COLOR}'
EXIT_STATUS="%(?..${OPEN_BRA}${RED}%?${RESET_COLOR}${CLOSE_BRA})"
PROMPT_END="${WHITE}: ${RESET_COLOR}"

# Function to change color of variables based on whether in normal 
# or insert mode.
function _zle_line_init _zle_keymap_select {
        # Colors required for this.
        autoload colors && colors
        # Color in insert mode.
        INSERT_COLOR="%B%F{green}"
        # Color of normal mode.
        NORMAL_COLOR="%B%F{red}"
        # Set current color based on mode.
        CURRENT_COLOR="${${KEYMAP/vicmd/${NORMAL_COLOR}}/(main|viins)/${INSERT_COLOR}}"
        # Redraw the prompt when this function is finished.
        zle reset-prompt
}

# Register this widget and replace the builtin zle-line-init 
# and zle-keymap-select
# (zle-line-init is executed every time the line editor is started 
# to read a new line of input, zle-keymap-select executed every time 
# the keymap changes, i.e. the special parameter KEYMAP is set to a 
# different value, while the line editor is active. Initialising the 
# keymap when the line editor starts does not cause the widget to be called. 
# This can be used for detecting switches between the vi command (vicmd) and insert (usually main) keymaps.
zle -N zle-line-init  _zle_line_init
zle -N zle-keymap-select _zle_keymap_select

# For VC options.
autoload -Uz vcs_info
# Enable this for git only.
zstyle ':vcs_info:*' enable git
# Just display the branch name in the prompt.
zstyle ':vcs_info:git*' formats  "%B%F{yellow}%b%f"

BRANCH='${GREY}${vcs_info_msg_0_}$RESET_COLOR'


# This function gets called before any command is executed.
function preexec() {
        timer=${timer:-$SECONDS}
}

# This function gets called before each prompt.
# It is not executed simplt because the command line is redrawn.
precmd() {
    # Updates the vc info variable.
    vcs_info

    if [ $timer ]; then
            timer_show=$(($SECONDS - $timer))
            TIME=$timer_show
            unset timer
    fi
}
# For the time of the last command.

# The Prompt.
PS1=${OPEN_BRA}${WORK_DIR}${CLOSE_BRA}${EXIT_STATUS}${OPEN_BRA}${PRIVLIGE}${CLOSE_BRA}${PROMPT_END}
# Remove any RS prompt.
RPS1=

