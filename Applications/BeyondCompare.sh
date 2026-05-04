#!/usr/bin/env zsh

function installAppBeyondCompare(){
    # --> Find dynamic download path for the latest version and build number
    local downloadVersion=$(curl -s "https://www.scootersoftware.com/download" | grep -o -m 1 '/files/BCompareOSX-[0-9.]\+\.zip')
    if [ -z "$downloadVersion" ]; then
        showinfo "Failed to extract App version from\nhttps://www.scootersoftware.com/download" "error"
        return 1 # error
    else
        local downloadUrl="https://www.scootersoftware.com$downloadVersion"
        # --> Download & Unzip
        downloadFromUrl "$downloadUrl" "BeyondCompare.zip"
        unzipFile "BeyondCompare.zip"
        # --> Move to Applications
        moveApplication "Beyond Compare.app"
    fi
}
export -f installAppBeyondCompare
