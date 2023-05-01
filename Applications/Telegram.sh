#!/usr/bin/env zsh

function installAppTelegram(){
	# --> Download
    downloadFromUrl "https://telegram.org/dl/macos" "Telegram.dmg"
   # --> Mount & move
   unmountFile "Telegram.dmg" "Telegram"
   moveApplication "Telegram.app"
}
export -f installAppTelegram
