#!/usr/bin/env zsh

# Check if Xcode Command Line Tools are installed
function checkIfXcodeInstalled(){
    local XcodeCLTinstallPath="/Library/Developer/CommandLineTools"
    if [ "$(xcode-select -p)" != "$XcodeCLTinstallPath" ]; then
        # Not installed
        showinfo "Xcode Command Line Tools are NOT installed" "note"
        return 1 # false
    else
        # Installed
        showinfo "Xcode Command Line Tools installed" "confirm"
        return 0 # true
    fi
}
export -f checkIfXcodeInstalled

# Install Xcode Command Line Tools
function installAppXcodeCLT(){
    # --> Notify first
    notify

    # --> Point xcode-select to the Xcode app Developer directory
    # Source: https://stackoverflow.com/a/48154263/5750030
    if checkIfUserIsAdmin; then
        sudo xcode-select --reset
        showinfo "Reset xcode-select" "note"
    else
        showinfo "Cannot reset xcode-select. Run the terminal command using sudo: sudo xcode-select --reset" "error"
    fi

    # --> Install
    xcode-select --install &>/dev/null

    # --> Configure xcode-select
    # Source: https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error#17980786
    if checkIfUserIsAdmin; then
        sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
        showinfo "Changed xcode-select directory" "note"
        sudo xcodebuild -license accept
        showinfo "Accepted xcode license agreement" "note"
    fi

    # --> Wait until the XCode Command Line Tools are installed
    # Source: https://github.com/rockholla/macosa/blob/master/bin/macosa_xcode
    until checkIfXcodeInstalled; do
        sleep 5
    done
}
export -f installAppXcodeCLT
