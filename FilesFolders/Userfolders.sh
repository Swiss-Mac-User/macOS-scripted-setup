#!/usr/bin/env zsh

# -- Userhome folders --
# --> User-only Applications
function createUserFolderApplications(){
    if ! checkIfFileExists "$HOME/Applications"; then
        mkdir "$HOME/Applications"
    fi
}
export -f createUserFolderApplications

# --> User-only (Web)Sites
function createUserFolderSites(){
    if ! checkIfFileExists "$HOME/Sites"; then
        mkdir "$HOME/Sites"
    fi
}
export -f createUserFolderSites

# --> User-only Games
function createUserFolderGames(){
    if ! checkIfFileExists "$HOME/Games"; then
        mkdir "$HOME/Games"
    fi

    # --> Download Games folder icon
    if [ "$useCustomGamesFolderIcon" = true ]; then
        downloadFromUrl "$useCustomGamesFolderIconURL" "icon.png"
        mv "$HOME/Downloads/icon.png" "$HOME/Games/foldericon.png"
    fi
}
export -f createUserFolderGames
