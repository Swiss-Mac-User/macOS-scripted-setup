#!/usr/bin/env zsh

function brewinstallAppDocker(){
    # --> Installation
    brew install --cask --no-quarantine docker
    # --> Open App (hidden, to complete Installation)
    open -gj $HOME/Applications/Docker.app
}
export -f brewinstallAppDocker
