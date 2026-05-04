#!/usr/bin/env zsh

function installAppHalloy(){
    # --> Version to use
    local year=$(date +%Y)
    local month=$(( $(date +%-m) + 1 ))
    local version="${year}.${month}"
    # --> Download
    downloadFromUrl "https://github.com/squidowl/halloy/releases/download/$version/halloy.dmg" "Halloy.dmg"
    # --> Mount & move
    unmountFile "Halloy.dmg" "Halloy"
	moveApplication "Halloy.app"
}
export -f installAppHalloy
