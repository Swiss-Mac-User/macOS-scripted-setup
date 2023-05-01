#!/usr/bin/env zsh

# -- FileVault2 --
# --> Check if FileVault is active
# Source: https://apple.stackexchange.com/q/70969/86244
function checkIfFileVaultOn(){
    if [ "$(fdesetup isactive)" = "true" ]; then
        return 0 # true (is active)
    else
        return 1 # false (not enabled)
    fi
}
export -f checkIfFileVaultOn

# --> Enable disk encryption of the macOS System Drive
function enableFileVault(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        if ! checkIfFileVaultOn; then
            # --> Notify first
            notify
            sudo fdesetup enable $(id -un)
        else
            # fdesetup status
            showinfo "FileVault is already enabled." "notice"
        fi
    else
        showinfo "'enableFileVault' requires root privileges. Run with an admin user, or using sudo." "error"
    fi
}
export -f enableFileVault
