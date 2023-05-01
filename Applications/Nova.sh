#!/usr/bin/env zsh

function installAppNova(){
    # --> Download & Unzip
    downloadFromUrl "https://download.panic.com/nova/Nova-Latest.zip" "Nova.zip"
    # --> Unzip
    unzipFile "Nova.zip"
    # --> Move to Applications
    moveApplication "Nova.app"
}
export -f installAppNova
