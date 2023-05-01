#!/usr/bin/env zsh

function installAppSpotify(){
	# --> Download & Unzip
	downloadFromUrl "https://download.scdn.co/SpotifyInstaller.zip" "SpotifyInstaller.zip"
	unzipFile "SpotifyInstaller.zip"
	# --> Launch Installer
	open "$HOME/Downloads/Install Spotify.app"
}
export -f installAppSpotify
