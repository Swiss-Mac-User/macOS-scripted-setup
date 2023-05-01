#!/usr/bin/env zsh

# -- Activity Monitor (Utilities App) --
# --> Change processes list view
function setActivityMonitorProcesslist(){
	# Show all Processes in Activity Monitor lists
	defaults write com.apple.ActivityMonitor "ShowCategory" -int 0
}
export -f setActivityMonitorProcesslist
