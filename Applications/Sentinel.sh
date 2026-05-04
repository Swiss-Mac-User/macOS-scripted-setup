#!/usr/bin/env zsh

function installAppSentinel(){
    # --> Version to use (default: latest)
    local version="3.1.4"
    # --> Download
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        downloadFromUrl "https://github.com/alienator88/Sentinel/releases/download/$version/Sentinel-arm.zip" "Sentinel.zip"
    else
        # ...for Intel-based Macs
		downloadFromUrl "https://github.com/alienator88/Sentinel/releases/download/$version/Sentinel-intel.zip" "Sentinel.zip"
    fi
    # --> Unzip & move
    unzipFile "Sentinel.zip"
	moveApplication "Sentinel.app"
}
export -f installAppSentinel
