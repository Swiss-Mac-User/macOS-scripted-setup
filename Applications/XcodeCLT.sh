#!/usr/bin/env zsh

function installAppXcodeCLT(){
    if ! checkIfXcodeInstalled; then
        # --> Notify first
        notify
        # --> Install
        xcode-select --install &>/dev/null

        # --> Wait until the XCode Command Line Tools are installed
        # Source: https://github.com/rockholla/macosa/blob/master/bin/macosa_xcode
        until checkIfXcodeInstalled; do
            sleep 5
        done
    fi
}
export -f installAppXcodeCLT
