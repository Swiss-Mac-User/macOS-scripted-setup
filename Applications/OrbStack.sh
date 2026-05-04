#!/usr/bin/env zsh

function installAppOrbStack(){
    # --> Set Download URL
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://orbstack.dev/download/stable/latest/arm64"
    else
        # ...for Intel-based Macs / Universal (Fallback)
        local downloadUrl="https://orbstack.dev/download/stable/latest/amd64"
    fi
    # --> Download
    downloadFromUrl "$downloadUrl" "OrbStack.dmg"
    # --> Mount, copy & unmount
    # (Cannot use unmountFile() function due to Volume having a different name than the App)
    local downloadFolder="$HOME/Downloads/"
    hdiutil attach "$downloadFolder/OrbStack.dmg" -quiet
    local orbVolume=(/Volumes/Install\ OrbStack\ v*/)
    ditto "${orbVolume[1]}OrbStack.app" "$downloadFolder/OrbStack.app"
    hdiutil unmount "${orbVolume[1]}" -force -quiet
    # --> Move
    moveApplication "OrbStack.app"
}
export -f installAppOrbStack

function brewinstallAppOrbStack(){
    # --> Installation
    brew install orbstack
}
export -f brewinstallAppOrbStack
