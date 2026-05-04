#!/usr/bin/env zsh

# -- macOS System Software Updates --
# --> List available Software Updates
function getSoftwareUpdates(){
    softwareupdate --list
}
export -f getSoftwareUpdates

# --> Install latest Software Updates
function installSoftwareUpdates(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo softwareupdate --install --all
    else
        echo "'softwareupdate --schedule' requires system administrator or root privileges. Run with an admin user, or using sudo."
    fi
}
export -f installSoftwareUpdates

# --> Automatic Software Updates
function enableSoftwareUpdateSchedule(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo softwareupdate --schedule
    else
        echo "'softwareupdate --schedule' requires system administrator or root privileges. Run with an admin user, or using sudo."
    fi
}
export -f enableSoftwareUpdateSchedule
