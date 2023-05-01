#!/usr/bin/env zsh

# -- User Login Window --
# Hide Shutdown Button on Login Window
function disableShutdownOnLogin(){
    defaults write com.apple.loginwindow "ShutDownDisabled" -bool TRUE
}
export -f disableShutdownOnLogin

# Remove Restart Button From Login Window:
function disableRestartOnLogin(){
    defaults write com.apple.loginwindow "RestartDisabled" -bool TRUE
}
export -f disableRestartOnLogin

# -- Screensaver --
# Require password immediately after sleep or screen saver begins
function enableUserpasswordOnScreensaver(){
    defaults write com.apple.screensaver "askForPassword" -int 1
    defaults write com.apple.screensaver "askForPasswordDelay" -int 0
}
export -f enableUserpasswordOnScreensaver
