#!/usr/bin/env zsh

function createUserFolderDesktopPictures(){
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures"; then
        mkdir "$HOME/Pictures/Desktop Pictures"
    fi
}
export -f createUserFolderDesktopPictures

# «Exodus» from dynamicwallpaper.club
function downloadWallpaperExodus(){
    # --> Check if not exists
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures/Exodus.heic"; then
        showinfo "...downloading «Exodus» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        # --> Download
        downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/1fwttqzokh6/Exodus%20by%20dpcdpc11.heic" "Exodus.heic"
        # --> Move
        mv "$HOME/Downloads/Exodus.heic" "$HOME/Pictures/Desktop Pictures/"
    else
        showinfo "Wallpaper 'Exodus' exists already" "note"
    fi
}
export -f downloadWallpaperExodus

# «Púšť» (Desert) from dynamicwallpaper.club
function downloadWallpaperDesert(){
    # --> Check if not exists
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures/Desert.heic"; then
        showinfo "...downloading «Púšť» (Desert) wallpaper to ~/Pictures/Desktop Pictures/" "note"
        # --> Download
        downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/r8aa55sjt28/Púšť.heic" "Desert.heic"
        # --> Move
        mv "$HOME/Downloads/Desert.heic" "$HOME/Pictures/Desktop Pictures/"
    else
        showinfo "Wallpaper 'Desert' exists already" "note"
    fi
}
export -f downloadWallpaperDesert

# «Fluted» from dynamicwallpaper.club
function downloadWallpaperFluted(){
    # --> Check if not exists
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures/Fluted.heic"; then
        showinfo "...downloading «Fluted» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        # --> Download
        downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/ngvc9u656rn/Fluted.heic" "Fluted.heic"
        # --> Move
        mv "$HOME/Downloads/Fluted.heic" "$HOME/Pictures/Desktop Pictures/"
    else
        showinfo "Wallpaper 'Fluted' exists already" "note"
    fi
}
export -f downloadWallpaperFluted

# «Fuji» from dynamicwallpaper.club
function downloadWallpaperFuji(){
    # --> Check if not exists
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures/Fuji.heic"; then
        showinfo "...downloading «Fuji» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        # --> Download
        downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/gpf7f97jk3b/Fuji.heic" "Fuji.heic"
        # --> Move
        mv "$HOME/Downloads/Fuji.heic" "$HOME/Pictures/Desktop Pictures/"
    else
        showinfo "Wallpaper 'Fuji' exists already" "note"
    fi
}
export -f downloadWallpaperFuji

# «Hivemind» from dynamicwallpaper.club
function downloadWallpaperHivemind(){
    # --> Check if not exists
    if ! checkIfFileExists "$HOME/Pictures/Desktop Pictures/Hivemind.heic"; then
        showinfo "...downloading «Hivemind» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        # --> Download
        downloadFromUrl "https://cdn.dynamicwallpaper.club/wallpapers/27ea4brg2szj/Hivemind.heic" "Hivemind.heic"
        # --> Move
        mv "$HOME/Downloads/Hivemind.heic" "$HOME/Pictures/Desktop Pictures/"
    else
        showinfo "Wallpaper 'Hivemind' exists already" "note"
    fi
}
export -f downloadWallpaperHivemind
