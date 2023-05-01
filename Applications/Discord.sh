#!/usr/bin/env zsh

function installAppDiscord(){
    # --> Download
    downloadFromUrl "https://discord.com/api/download?platform=osx" "Discord.dmg"
    # --> Mount & move
    unmountFile "Discord.dmg" "Discord"
    moveApplication "Discord.app"
}
export -f installAppDiscord
