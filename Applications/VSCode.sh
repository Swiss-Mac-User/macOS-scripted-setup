#!/usr/bin/env zsh

function installAppVSCode(){
    # --> Version to use (default: latest)
    local version="latest"
    # --> Set Download URL
    if checkIfAppleSilicion; then
        # ...for ARM-based Apple Silicon Macs
        local downloadUrl="https://update.code.visualstudio.com/$version/cli-darwin-arm64/stable"
    else
        # ...for Intel-based Macs / Universal (Fallback)
        local downloadUrl="https://update.code.visualstudio.com/$version/darwin-universal/stable"
    fi
    # --> Download & Unzip
    downloadFromUrl "$downloadUrl" "VSCode.zip"
    unzipFile "VSCode.zip"
    # --> Move to Applications
    moveApplication "Visual Studio Code.app"
}
export -f installAppVSCode
