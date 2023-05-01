#!/usr/bin/env zsh

function installAppXnapper(){
    # --> Find dynamic download URL of current version
    local downloadUrl=$(curl -s "https://xnapper.com/" | grep -o 'https://xnapper.com/dmg/Xnapper-[0-9\.]\{4,\}\.dmg' | sed -n '1p')
    # --> Download
    downloadFromUrl "$downloadUrl" "Xnapper.dmg"
    # --> Mount & move
    unmountFile "Xnapper.dmg" "Xnapper"
    moveApplication "Xnapper.app"
}
export -f installAppXnapper
