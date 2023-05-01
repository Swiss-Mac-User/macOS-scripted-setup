#!/usr/bin/env zsh

# -- Mission Control --
# --> Multiple Displays use separate Spaces
function useMissionControlSpacePerDisplay(){
	# Each Display uses an independent Space
	defaults write com.apple.spaces "spans-displays" -bool FALSE
}
export -f useMissionControlSpacePerDisplay

# --> In Mission Control, open windows are grouped by Application
function groupMissionControlByApplication(){
	# Mission Control groups open windows by Application
	defaults write com.apple.dock "expose-group-apps" -bool TRUE
}
export -f groupMissionControlByApplication

# --> Select Space with open Application windows
function switchMissionControlSpacesByApplication(){
	# When selecting Application, switch to Space with its open windows
	defaults write com.apple.dock "AppleSpacesSwitchOnActivate" -bool TRUE
}
export -f switchMissionControlSpacesByApplication

# --> Define Hot Corners
function setMissionControlHotCorners(){
	# -- Mission Control (Hot corners) --
	# Possible values:
	#    0: not assigned
	#    2: Mission Control
	#    3: Show application windows
	#    4: Desktop
	#    5: Start screen saver
	#    6: Disable screen saver
	#    7: Dashboard
	#   10: Put display to sleep
	#   11: Launchpad
	#   12: Notification Center
	#   13: Lock Screen
	# --> Top left screen corner → Do nothing
	defaults write com.apple.dock "wvous-tl-corner" -int 0
	defaults write com.apple.dock "wvous-tl-modifier" -int 0
	# --> Top right screen corner → Mission Control
	defaults write com.apple.dock "wvous-tr-corner" -int 2
	defaults write com.apple.dock "wvous-tr-modifier" -int 0
	# --> Bottom left screen corner → Start screen saver
	defaults write com.apple.dock "wvous-bl-corner" -int 13
	defaults write com.apple.dock "wvous-bl-modifier" -int 0
	# --> Bottom right screen corner → Desktop
	defaults write com.apple.dock "wvous-br-corner" -int 4
	defaults write com.apple.dock "wvous-br-modifier" -int 0
}
export -f setMissionControlHotCorners
