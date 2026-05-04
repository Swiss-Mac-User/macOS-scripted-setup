#!/usr/bin/env zsh

# Keyboard fn 🌐 key shows Emoji & Symbols popup. Supported values:
# --> 0 = No function / do nothing (default)
# --> 1 = Change keyboard input source
# --> 2 = Show "Emoji & Symbols"
# --> 3 = Start Dictation (press 2x)
function useFnKeyFor(){
    local changeMode=false
    local configFnKeyFunction=$1
    case "$configFnKeyFunction" in
        off) changeMode=0;;
        language) changeMode=1;;
        emoji) changeMode=2;;
        dictation) changeMode=3;;
        *) changeMode=false;;
    esac

    if [ "$changeMode" != false ]; then
        defaults write com.apple.HIToolbox "AppleFnUsageType" -int $changeMode
    fi
}
export -f useFnKeyFor

# Move selected element focus with Tab / Shift Tab
function useTabForElementFocus(){
    defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"
}
export -f useTabForElementFocus
