#!/usr/bin/env zsh

# -- Control Centre --
# --> Show Fast User Switching Icon
function showFastUserSwitching(){
	# Show Fast User Switcher in Menu Bar (use -int 9 = in CC)
	defaults write com.apple.controlcenter "UserSwitcher" -int 6
	defaults write com.apple.controlcenter "NSStatusItem Visible UserSwitcher" -int 1
}
export -f showFastUserSwitching

# --> Show % for Battery
function showBatteryPercentage(){
	# Show the Battery Icon in Menu Bar
	defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -int 1
	# Show the Battery % Percentage in Menu Bar
	defaults write com.apple.controlcenter "BatteryShowPercentage" -bool TRUE
}
export -f showBatteryPercentage
