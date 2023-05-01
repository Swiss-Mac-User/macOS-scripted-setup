#!/usr/bin/env zsh

function installAppWarp(){
    # --> Download
    downloadFromUrl "https://app.warp.dev/download" "Warp.dmg"
    # --> Mount & move
    unmountFile "Warp.dmg" "Warp"
    moveApplication "Warp.app"
}
export -f installAppWarp
