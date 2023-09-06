#!/usr/bin/env zsh

function installAppSteam(){
	# --> Download
	downloadFromUrl "https://cdn.akamai.steamstatic.com/client/installer/steam.dmg" "Steam.dmg"
	# --> Mount & move (and open)
	unmountFile "Steam.dmg" "Steam"
	moveApplication "Steam.app" #"open" -> Disabled due to Quarantine warning
}
export -f installAppSteam
