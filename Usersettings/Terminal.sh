#!/usr/bin/env zsh

# --> Only use UTF-8 in Terminal.app
function enableTerminalUtf8(){
    defaults write com.apple.Terminal "StringEncodings" -array 4
}
export -f enableTerminalUtf8

# --> Terminal custom Profile-Theme
function downloadTerminalCustomTheme(){
    downloadFromUrl "$useCustomTerminalThemeURL" "MyCustomTheme.terminal"
    importTerminalCustomTheme
    setTerminalCustomThemeAsDefault
}
export -f downloadTerminalCustomTheme

# --> Import the custom Terminal theme
function importTerminalCustomTheme(){
    osascript <<EOD
tell application "Terminal"
    activate
    set TerminalThemeFile to (POSIX path of ((path to home folder) as text) & "Downloads/MyCustomTheme.terminal")
    open TerminalThemeFile
    delay 1
end tell
EOD
}
export -f importTerminalCustomTheme

# Use the custom Terminal theme by default in Terminal.app
function setTerminalCustomThemeAsDefault(){
    defaults write com.apple.Terminal "Startup Window Settings" -string "MyCustomTheme"
    defaults write com.apple.Terminal "Default Window Settings" -string "MyCustomTheme"
}
export -f setTerminalCustomThemeAsDefault

# --> Apply custom Terminal Commands
function downloadTerminalzshrcContents(){
    local zshrcContentsLocation=$HOME/Downloads/Add\ to\ zshrc.txt
    downloadFromUrl "$useCustomTerminalConfigurationsURL" "$zshrcContentsLocation"
    if checkIfFileExists "$zshrcContentsLocation"; then
        "$zshrcContentsLocation" >> $HOME/.zshrc
    fi
}
export -f downloadTerminalzshrcContents
