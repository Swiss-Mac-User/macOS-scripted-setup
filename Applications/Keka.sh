#!/usr/bin/env zsh

function installAppKeka(){
	# --> Download
	downloadFromUrl "https://d.keka.io/" "Keka.dmg"
	# --> Mount & move (and open)
	unmountFile "Keka.dmg" "Keka"
	moveApplication "Keka.app" #"open" -> Disabled due to Quarantine warning
}
export -f installAppKeka
