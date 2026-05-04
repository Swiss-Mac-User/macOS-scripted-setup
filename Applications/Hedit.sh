#!/usr/bin/env zsh

function installAppHedit(){
    # --> Version to use (default: latest)
    local version="0.6.0"
    # --> Download
    if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs
        downloadFromUrl "https://github.com/valtlfelipe/hedit/releases/download/v$version/Hedit_$version_aarch64.dmg" "Hedit_aarch64.dmg"
    else
        # ...for Intel-based Macs
		downloadFromUrl "https://github.com/valtlfelipe/hedit/releases/download/v$version/Hedit_$version_x64.dmg" "Hedit_x64.dmg"
    fi
    # --> Mount & move (and open)
    unmountFile "Hedit.dmg" "Hedit"
    moveApplication "Hedit.app"
}
export -f installAppHedit
