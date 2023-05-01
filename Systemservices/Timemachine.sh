#!/usr/bin/env zsh

# -- Time Machine settings --
# --> Prevent Time Machine asking to use new Disks as backup volume
function muteTimeMachine(){
    defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool TRUE
}
export -f muteTimeMachine

# --> Speed-up Time Machine backups
function speedupTimeMachine(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo sysctl debug.lowpri_throttle_enabled=0
    else
        echo "'speedupTimeMachine' requires system administrator privileges. Run with an admin user, or using sudo."
    fi
}
export -f speedupTimeMachine
