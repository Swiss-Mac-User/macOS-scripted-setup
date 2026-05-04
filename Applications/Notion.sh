#!/usr/bin/env zsh

function installAppNotion(){
    # --> Set Download URL
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://www.notion.com/desktop/mac-apple-silicon/download"
    else
        # ...for Intel-based Macs / Universal (Fallback)
        local downloadUrl="https://www.notion.com/desktop/mac-universal/download"
    fi
    # --> Download
    downloadFromUrl "$downloadUrl" "Notion.dmg"
    # --> Mount, copy & unmount
    # (Cannot use unmountFile() function due to Volume having a different name than the App)
    local downloadFolder="$HOME/Downloads/"
    hdiutil attach "$downloadFolder/Notion.dmg" -quiet
    ditto "/Volumes/Notion Installer/Notion.app" "$downloadFolder/Notion.app"
    hdiutil unmount "/Volumes/Notion Installer" -force -quiet
    # --> Move
    moveApplication "Notion.app"
}
export -f installAppNotion
