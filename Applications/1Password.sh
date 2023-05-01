#!/usr/bin/env zsh

function installApp1Password(){
	# --> Download & Unzip
	downloadFromUrl "https://downloads.1password.com/mac/1Password.zip" "1PasswordInstaller.zip"
	unzipFile "1PasswordInstaller.zip"
	# --> Launch Installer
	open "$HOME/Downloads/1Password Installer.app"
}
export -f installApp1Password

# "1Password for Safari" Browser Extension
function masinstallApp1PasswordSafariExtension(){
	# https://apps.apple.com/ch/app/1password-for-safari/id1569813296
	mas install 1569813296
}
export -f masinstallApp1PasswordSafariExtension
