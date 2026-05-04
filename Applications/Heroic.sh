#!/usr/bin/env zsh

# Transmission.app
function installAppHeroicGamesLauncher(){
    # --> App version to use
    local version="2.14.1"
    local platform="-arm64"
    # --> Set Download URL
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$version/Heroic-$version-macOS-arm64.dmg"
    else
        # ...for Intel-based Macs
        platform=""
        local downloadUrl="https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v$version/Heroic-$version-macOS-x64.dmg"
    fi
    # --> Download
    downloadFromUrl "$downloadUrl" "Heroic.dmg"
    # --> Mount, copy & unmount
    # (Cannot use unmountFile() — volume name includes version number)
    local downloadFolder="$HOME/Downloads/"
    hdiutil attach "$downloadFolder/Heroic.dmg" -quiet
    ditto "/Volumes/Heroic $version$platform/Heroic.app" "$downloadFolder/Heroic.app"
    hdiutil unmount "/Volumes/Heroic $version$platform" -force -quiet
    # --> Move
    moveApplication "Heroic.app"
}
export -f installAppHeroicGamesLauncher
