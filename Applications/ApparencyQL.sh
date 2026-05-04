#!/usr/bin/env zsh

function brewinstallAppApparency(){
    # --> Installation
    brew install apparency
    # --> Open App (hidden)
    open -gj "/Applications/Apparency.app"
    # --> Close App again (not actively needed)
    sleep 5
    killall "Apparency" &>/dev/null
}
export -f brewinstallAppApparency
