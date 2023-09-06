#!/usr/bin/env zsh

function createUserFolderDesktopPictures(){
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures"; then
        mkdir "$HOME/Pictures/Desktop Pictures"
    fi
}
export -f createUserFolderDesktopPictures

# «Fuji» from dynamicwallpaper.club
function downloadWallpaperFuji(){
    # --> Download
    downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/gpf7f97jk3b/Fuji.heic" "Fuji.heic"
    # --> Move
    mv "$HOME/Downloads/Fuji.heic" "$HOME/Pictures/Desktop Pictures/"
}
export -f downloadWallpaperFuji

# «Exodus» from dynamicwallpaper.club
function downloadWallpaperExodus(){
    # --> Download
    downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/1fwttqzokh6/Exodus%20by%20dpcdpc11.heic" "Exodus.heic"
    # --> Move
    mv "$HOME/Downloads/Exodus.heic" "$HOME/Pictures/Desktop Pictures/"
}
export -f downloadWallpaperExodus

# «ISS» from dynwalls.com
function downloadWallpaperISS(){
    # --> Download
    downloadFromUrl "https://dynwalls.com/wallpapers/ISS.heic" "ISS.heic"
    # --> Move
    mv "$HOME/Downloads/ISS.heic" "$HOME/Pictures/Desktop Pictures/"
}
export -f downloadWallpaperISS
