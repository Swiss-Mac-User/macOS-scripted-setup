#!/usr/bin/env zsh

# -- Play sound on startup --
# --> Enable playing the mesmerising Mac Startup Sound
# Source: https://appleinsider.com/articles/20/02/22/how-to-turn-your-mac-startup-chime-back-on
function enableStartupChime(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo nvram StartupMute="%00"
    else
        echo "'enableStartupChime' requires system administrator or root privileges. Run with an admin user, or using sudo."
    fi
}
export -f enableStartupChime
