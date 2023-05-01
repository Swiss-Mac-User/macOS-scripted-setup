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
