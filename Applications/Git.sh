#!/usr/bin/env zsh

# Install Git
function brewinstallAppGit(){
    # --> Installation
    brew install git
}
export -f brewinstallAppGit

# Install git-credentials-manager
# Fixes and issue with Fork.app: https://github.com/fork-dev/Tracker/issues/1397#issuecomment-2246336011
function brewinstallAppGitCredentialsManager(){
    # --> Notify first
    notify
    # --> Installation
    brew install --cask git-credential-manager
}
export -f brewinstallAppGitCredentialsManager
