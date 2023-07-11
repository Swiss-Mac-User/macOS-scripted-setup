#!/usr/bin/env zsh

function installAppVLC(){
    # --> Find current version and build number for dynamic download URL
    local version=$(curl -s "http://www.videolan.org/vlc/download-macosx.html" | awk -F '[<>]' '/<span id='"'"'downloadVersion'"'"'>/{getline; sub(/^[[:space:]]+/, ""); sub(/<\/span>.*/, ""); print}')
    if [ -z "$version" ]; then
        showinfo "Failed to extract App version from\nhttps://www.videolan.org/vlc/download-macosx.html" "error"
        return 1 # error
    else
        # --> Set Download URL
        if checkIfAppleSilicion; then
            # ...for ARM-based Apple Silicon Macs
            local downloadUrl="http://get.videolan.org/vlc/$version/macosx/vlc-$version-arm64.dmg"
        else
            # ...for Intel-based Macs
            local downloadUrl="http://get.videolan.org/vlc/$version/macosx/vlc-$version-intel64.dmg"
        fi
        # --> Download
        local downloadFolder="$HOME/Downloads/"
        downloadFromUrl "$downloadUrl" "VLC.dmg"
        # --> Mount & copy
        # (Cannot use unmountFile() function due to VLC Volume having a different name than the App)
        hdiutil attach "$downloadFolder/VLC.dmg" -quiet
        cp -r "/Volumes/VLC media player/VLC.app" "$downloadFolder"
        # --> Unmount & move
        hdiutil unmount "/Volumes/VLC media player" -force -quiet
        moveApplication "VLC.app"
    fi
}
export -f installAppVLC
