#!/usr/bin/env zsh

function installAppMAMP(){
    # --> MAMP version to use
    local version="6.9"
    # --> Set Download URL
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://downloads.mamp.info/MAMP-PRO/releases/$version/MAMP_MAMP_PRO_$version-M1-arm.pkg"
    else
        # ...for Intel-based Macs
        local downloadUrl="https://downloads.mamp.info/MAMP-PRO/releases/$version/MAMP_MAMP_PRO_$version-Intel-x86.pkg"
    fi
    # --> Download
    downloadFromUrl "$downloadUrl" "MAMP.pkg"
    # --> Launch Package Installer
    installer -pkg "$HOME/Downloads/MAMP.pkg" -target /
}
export -f installAppMAMP
