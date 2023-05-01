#!/usr/bin/env zsh

# Transmission.app
function installAppTransmission(){
    # --> Download
    downloadFromUrl "https://github.com/transmission/transmission/releases/download/3.00/Transmission-3.00.dmg" "Transmission.dmg"
    # --> Mount & move
    unmountFile "Transmission.dmg" "Transmission"
    moveApplication "Transmission.app"
    # --> Configure App
    configureAppTransmission
}
export -f installAppTransmission

# Transmission.app configurations
function configureAppTransmission(){
    # Use `~/Downloads` to store incomplete and complete downloads
    defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
    defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads"
    defaults write org.m0k.transmission DownloadLocationConstant -bool true

    # Don’t prompt for confirmation before downloading
    defaults write org.m0k.transmission DownloadAsk -bool false
    defaults write org.m0k.transmission MagnetOpenAsk -bool false

    # Don’t prompt for confirmation before removing non-downloading active transfers
    defaults write org.m0k.transmission CheckRemoveDownloading -bool true

    # Trash original torrent files
    defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

    # Hide the donate message
    defaults write org.m0k.transmission WarningDonate -bool false
    # Hide the legal disclaimer
    defaults write org.m0k.transmission WarningLegal -bool false

    # Randomize port on launch
    defaults write org.m0k.transmission RandomPort -bool true

    # IP block list.
    defaults write org.m0k.transmission BlocklistNew -bool true
    defaults write org.m0k.transmission BlocklistURL -string "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
    defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
}
export -f configureAppTransmission
