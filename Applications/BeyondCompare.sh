#!/usr/bin/env zsh

function installAppBeyondCompare(){
    # --> Find current version and build number for dynamic download URL
    local version=$(curl -s "https://www.scootersoftware.com/download.php" | awk -F '[, .]+' '/Current Version:/ {print $3"."$4"."$5"."$7}' | sed 's/[[:space:]]//g')
    if [ -z "$version" ]; then
        showinfo "Failed to extract App version from\nhttps://www.scootersoftware.com/download.php" "error"
        return 1 # error
    else
        local downloadUrl="https://www.scootersoftware.com/BCompareOSX-$version.zip"
        # --> Download & Unzip
        downloadFromUrl "$downloadUrl" "BeyondCompare.zip"
        unzipFile "BeyondCompare.zip"
        # --> Move to Applications
        moveApplication "Beyond Compare.app"
    fi
}
export -f installAppBeyondCompare
