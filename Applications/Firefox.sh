#!/usr/bin/env zsh

function installAppFirefox(){
    # --> Download
    downloadFromUrl "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" "Firefox.dmg"
    # --> Mount & move
    unmountFile "Firefox.dmg" "Firefox"
    moveApplication "Firefox.app"
}
export -f installAppFirefox
