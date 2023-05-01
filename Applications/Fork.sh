#!/usr/bin/env zsh

function installAppFork(){
    # --> Fork version to use
    local download_link=$(curl -s "https://git-fork.com/" | sed -n 's/.*id="downloadBtn1Mac".*href="\([^"]*\)".*/\1/p')
    # --> Download
    downloadFromUrl "$download_link" "Fork.dmg"
    # --> Mount & move (and open)
    unmountFile "Fork.dmg" "Fork"
    moveApplication "Fork.app" #"open" -> Disabled due to Quarantine warning
}
export -f installAppFork
