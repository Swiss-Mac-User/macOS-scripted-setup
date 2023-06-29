#!/usr/bin/env zsh

function installAppMicrosoftOffice(){
    # --> Set Download URL
    # Source: https://learn.microsoft.com/en-us/deployoffice/mac/deployment-options-for-office-for-mac
    local downloadUrl="https://go.microsoft.com/fwlink/p/?linkid=2009112"
    # --> Download
    downloadFromUrl "$downloadUrl" "MSOfficeForMac.pkg"
    # --> Launch Package Installer
    installer -pkg "$HOME/Downloads/MSOfficeForMac.pkg" -target /
}
export -f installAppMicrosoftOffice
