#!/usr/bin/env zsh

# Homebrew installation
function installAppHomebrew(){
    if ! checkIfHomebrewInstalled; then
        # --> Add Homebrew to User's PATH
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source $HOME/.zprofile

        # --> Check for Xcode CLT
        # (pre-requisite for Homebrew)
        if ! checkIfXcodeInstalled; then
            installAppXcodeCLT
        fi

        # --> Notify
        notify
        # --> Installation
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # --> Configure Homebrew
        configureAppHomebrew
    fi
}
export -f installAppHomebrew

# Homebrew configurations
function configureAppHomebrew(){
    # Enable Homebrew's Auto-Update (requires LaunchAgents directory)
    mkdir -p "$HOME/Library/LaunchAgents"
    brew autoupdate start --upgrade
}
export -f configureAppHomebrew
