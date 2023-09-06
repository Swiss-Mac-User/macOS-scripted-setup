#!/usr/bin/env zsh

# -- MacBook Trackpad behaviours --
# --> Improve Trackpad Click behaviours (single and right click)
function enableTrackpadClicking(){
	# Enable Single Tap to Click
	defaults write com.apple.AppleMultitouchTrackpad "Clicking" -int 1
	# Enable Right Click
	defaults write com.apple.AppleMultitouchTrackpad "TrackpadRightClick" -int 1
}
export -f enableTrackpadClicking

# --> Increase Mouse speed on Trackpads and Mouses
function increaseMouseSpeed(){
	# -g = Setting is in .GlobalPreferences.plist
	defaults write -g com.apple.trackpad.scaling -int 2
	defaults write -g com.apple.mouse.scaling -float 1.5
}
export -f increaseMouseSpeed
