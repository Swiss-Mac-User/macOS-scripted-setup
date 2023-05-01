#!/usr/bin/env zsh

# Prevent Photos from opening automatically when devices are plugged in
function preventAutoImportPhotos(){
	defaults write com.apple.ImageCapture "disableHotPlug" -bool TRUE
}
export -f preventAutoImportPhotos
