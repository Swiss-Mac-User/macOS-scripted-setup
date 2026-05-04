#!/usr/bin/env zsh

# -- Displays settings --
# --> Show all resolutions
function showAllDisplayResolutions(){
    defaults write com.apple.Displays-Settings.extension "showListByDefault" -int 2
}
export -f showAllDisplayResolutions
