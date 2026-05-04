#!/usr/bin/env zsh

function installAppSteam(){
	if checkIfAppleSilicon; then
        # ...for ARM-based Apple Silicon Macs: run github.com/i1rr/steam-arm64-mac
        curl -fsSL https://raw.githubusercontent.com/i1rr/steam-arm64-mac/main/install.sh | bash
    else
        # ...for Intel-based Macs: regular Download
		downloadFromUrl "https://cdn.akamai.steamstatic.com/client/installer/steam.dmg" "Steam.dmg"
		# --> Mount & move (and open)
		unmountFile "Steam.dmg" "Steam"
		moveApplication "Steam.app"
    fi
}
export -f installAppSteam
