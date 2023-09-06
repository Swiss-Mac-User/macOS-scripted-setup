#!/usr/bin/env zsh

function installAppWhisky(){
    # --> Download & Unzip
    downloadFromUrl "https://github.com/Whisky-App/Whisky/releases/latest/download/Whisky.zip" "Whisky.zip"
    # --> Unzip
    unzipFile "Whisky.zip"
    # --> Move & open Application
    moveApplication "Whisky.app" "open"
}
export -f installAppWhisky
