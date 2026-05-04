#!/usr/bin/env zsh

function installAppTresorit(){
	# --> Download
	downloadFromUrl "https://installer.tresorit.com/Tresorit.dmg" "Tresorit.dmg"
	# --> Mount & move (and open)
	unmountFile "Tresorit.dmg" "Tresorit"
	moveApplication "Tresorit.app"
}
export -f installAppTresorit
