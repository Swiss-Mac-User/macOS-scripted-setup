#!/usr/bin/env zsh

# -- Remove Apple's Garageband.app --
function removeAppGarageband(){
	local location="/Applications/GarageBand.app"
	if checkIfFileExists "$location"; then
		rm "$location"
	fi
}
export -f removeAppGarageband

# -- Remove Apple's iMovie.app --
function removeAppiMovie(){
	local location="/Applications/iMovie.app"
	if checkIfFileExists "$location"; then
		rm "$location"
	fi
}
export -f removeAppiMovie
