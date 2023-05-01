#!/usr/bin/env zsh

function installAppGoogleChrome(){
    # --> Download
    downloadFromUrl "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg" "GoogleChrome.dmg"
    # --> Mount & move
    unmountFile "GoogleChrome.dmg" "Google Chrome"
    moveApplication "Google Chrome.app"
    # --> Configure App
    configureAppGoogleChrome
}
export -f installAppGoogleChrome

function configureAppGoogleChrome(){
    # Disable the all too sensitive backswipe on trackpads
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
    defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool FALSE

    # Disable the all too sensitive backswipe on Magic Mouse
    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool FALSE
    defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool FALSE

    # Use the system-native print preview dialog
    defaults write com.google.Chrome DisablePrintPreview -bool TRUE
    defaults write com.google.Chrome.canary DisablePrintPreview -bool TRUE

    # Expand the print dialog by default
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool TRUE
    defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool TRUE
}
export -f configureAppGoogleChrome
