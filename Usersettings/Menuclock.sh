#!/usr/bin/env zsh

# Menuclock settings
# 	- FlashDateSeparators = true/false
# 	- IsAnalog = true/false
# 	- ShowAMPM = true/false
# 	- Show24Hour = true/false
# 	- ShowDate = true/false
# 	- ShowDayOfWeek = true/false
# 	- ShowSeconds = true/false
function setReadableMenuclock(){
    defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool FALSE
    defaults write com.apple.menuextra.clock "IsAnalog" -bool FALSE
    defaults write com.apple.menuextra.clock "ShowAMPM" -bool FALSE
    defaults write com.apple.menuextra.clock "Show24Hour" -bool TRUE
    defaults write com.apple.menuextra.clock "ShowDate" -bool TRUE
    defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool TRUE
    defaults write com.apple.menuextra.clock "ShowSeconds" -bool TRUE
}
export -f setReadableMenuclock
