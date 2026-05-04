#!/usr/bin/env zsh

function installAppOverSight(){
    # --> Version to use (default: latest)
    local version="2.4.0"
    # --> Download & Unzip
    downloadFromUrl "https://github.com/objective-see/OverSight/releases/latest/download/OverSight_$version.zip" "OverSight.zip"
    # --> Unzip
    unzipFile "OverSight.zip"
    # --> Launch Installer
	open "$HOME/Downloads/OverSight Installer.app"
}
export -f installAppOverSight
