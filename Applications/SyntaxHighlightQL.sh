#!/usr/bin/env zsh

function brewinstallAppSyntaxHighlight(){
    # --> Installation
    brew install --cask --no-quarantine syntax-highlight
    # --> Open App (hidden)
    open -gj "/Applications/Syntax Highlight.app"
}
export -f brewinstallAppSyntaxHighlight
