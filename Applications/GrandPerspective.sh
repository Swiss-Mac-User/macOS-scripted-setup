#!/usr/bin/env zsh

function installAppGrandPerspective(){
    # --> Version
    local version="3.4.2"
    # --> Download
    downloadFromUrl "https://downloads.sourceforge.net/project/grandperspectiv/grandperspective/$version/GrandPerspective-3_4_2.dmg?ts=gAAAAABlBrA5VHhuRY9rcLD3hJgR2C3IQciYRJgp5UlHW-BBkHMzhcBWavFsEdHTYCFyKnHWoc_COkxXYhEn37gEWywXjkMo0w%3D%3D" "GrandPerspective.dmg"
    # --> Mount, copy & unmount
    # (Cannot use unmountFile() — volume name differs from app name)
    local downloadFolder="$HOME/Downloads/"
    hdiutil attach "$downloadFolder/GrandPerspective.dmg" -quiet
    ditto "/Volumes/GrandPerspective $version/GrandPerspective.app" "$downloadFolder/GrandPerspective.app"
    hdiutil unmount "/Volumes/GrandPerspective $version" -force -quiet
    # --> Move
    moveApplication "GrandPerspective.app"
}
export -f installAppGrandPerspective
