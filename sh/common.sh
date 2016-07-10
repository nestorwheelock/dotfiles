#!/bin/sh

# Some general configuration common to most shells
# Should be compatible with at least: sh, bash, ksh, zsh

# Additional locations to prefix to our PATH
EXTRA_PATHS=''

# Our preferred text editors ordered by priority
EDITOR_PRIORITY='vim vi nano pico'

# Preserve our original PATH for use in some later munging
original_path="$PATH"

# Quick and dirty function to help manage adding to the PATH
function path_add_prefix() {
    if [ $# -eq 2 ]; then
        if [ -n "$1" -a -n "$2" ]; then
            echo "$1:$2"
        else
            echo "$1$2"
        fi
    else
        echo 'Called path_add_prefix with an invalid number of parameters!'
    fi
}

# Add any extra paths before we run the system specific stuff
path_changes_general=$(path_add_prefix "$EXTRA_PATHS" "$path_changes_general")

# If a bin directory exists in our home directory then add it
if [ -d "$HOME/bin" ]; then
    path_changes_general=$(path_add_prefix "$HOME/bin" "$path_changes_general")
fi

# Update the PATH with any changes we've recorded
if [ -n "$path_changes_general" ]; then
    export PATH="$path_changes_general:$PATH"
fi

# Operating system and environment specific configurations
kernel_name=$(uname -s)
if [ "${kernel_name#*CYGWIN_NT}" != "$kernel_name" ]; then
    # shellcheck source=sh/systems/cygwin.sh
    source "$HOME/dotfiles/sh/systems/cygwin.sh"
elif [ "${kernel_name#*Darwin}" != "$kernel_name" ]; then
    # shellcheck source=sh/systems/osx.sh
    source "$HOME/dotfiles/sh/systems/osx.sh"
elif [ "${kernel_name#*Linux}" != "$kernel_name" ]; then
    # shellcheck source=sh/systems/linux.sh
    source "$HOME/dotfiles/sh/systems/linux.sh"
fi

# Construct the final PATH with both the general and system changes
if [ -n "$path_changes_system" ]; then
    path_changes="$path_changes_system"
fi
if [ -n "$path_changes_general" ]; then
    path_changes=$(path_add_prefix "$path_changes_general" "$path_changes")
fi
if [ -n "$path_changes" ]; then
    export PATH="$path_changes:$original_path"
fi

# Additional configurations for various applications
if [ -d "$HOME/dotfiles/sh/apps" ]; then
    for app in $(ls "$HOME/dotfiles/sh/apps"); do
        # shellcheck source=/dev/null
        source "$HOME/dotfiles/sh/apps/$app"
    done
fi

# Figure out which editor to default to
for editor in $(echo $EDITOR_PRIORITY); do
    editor_path=$(command -v $editor)
    if [ -n "$editor_path" ]; then
        export EDITOR="$editor_path"
        export VISUAL="$editor_path"
        break
    fi
done

# If we defined a custom aliases file then include it
if [ -f "$HOME/dotfiles/sh/aliases.sh" ]; then
    # shellcheck source=sh/aliases.sh
    source "$HOME/dotfiles/sh/aliases.sh"
fi

# If we defined a custom functions folder then include it
if [ -d "$HOME/dotfiles/sh/functions" ]; then
    for function in $(ls "$HOME/dotfiles/sh/functions"); do
        # shellcheck source=/dev/null
        source "$HOME/dotfiles/sh/functions/$function"
    done
fi

# Disable toggling flow control (use ixany to re-enable)
stty -ixon

# vim: syntax=sh cc=80 tw=79 ts=4 sw=4 sts=4 et sr
