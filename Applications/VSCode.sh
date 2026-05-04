#!/usr/bin/env zsh

function installAppVSCode(){
    # --> Version to use (default: latest)
    local version="latest"
    # --> Set Download URL
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://update.code.visualstudio.com/$version/darwin-arm64/stable"
    else
        # ...for Intel-based Macs / Universal (Fallback)
        local downloadUrl="https://update.code.visualstudio.com/$version/darwin-universal/stable"
    fi
    # --> Download
    downloadFromUrl "$downloadUrl" "VSCode.dmg"
    # --> Mount, copy & unmount
    # (Cannot use unmountFile() function due to Volume having a different name than the App)
    local downloadFolder="$HOME/Downloads/"
    hdiutil attach "$downloadFolder/VSCode.dmg" -quiet
    ditto "/Volumes/VS Code/Visual Studio Code.app" "$downloadFolder/Visual Studio Code.app"
    hdiutil unmount "/Volumes/VS Code" -force -quiet
    # --> Move
    moveApplication "Visual Studio Code.app"
}
export -f installAppVSCode
