#!/usr/bin/env zsh

# Send a Beep to get attention in the Terminal
function notify(){
    afplay /System/Library/Sounds/Blow.aiff
    open /System/Applications/Utilities/Terminal.app
}
export -f notify

# echo a string to the CLI
function showinfo(){
    # Define font style
    local REGULAR=$(tput sgr0)
    local BOLD=$(tput bold)
    # Define colors
    local NOCOLOR='\033[0m'
    local GREEN='\033[0;32m'
    local BLUE='\033[0;34m'
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local GRAY='\033[1;30m'

    # Check if 2nd Parameter is passed
    if [ -n "$2" ]; then
        case "$2" in
            note) echout="\n$1";;
            shout) echout="\n\n${BLUE}$1\n------------------------------${NOCOLOR}";;
            confirm) echout="$1...${GREEN}done ✅${NOCOLOR}\n";;
            error) echout="\n❌ ${RED}$1${NOCOLOR}\n";;
            notice) echout="\n💡 ${YELLOW}$1${NOCOLOR}\n";;
            blank) echout="";;
            *) echout="$1";;
        esac
    else
        echout="$1"
    fi
    echo -e "$echout"
}
export -f showinfo

# Check if a variable is not empty and not whitespace
function checkIfNotEmpty() {
    if [ -n "$1" ]; then
        # Is NOT empty
        return 0 # true
    else
        # Is empty
        return 1 # false
    fi
}
export -f checkIfNotEmpty

# Check if a local path exists and is readable
function checkIfFileExists(){
    if [ -r "$1" ]; then
        # Found (and readable)
        return 0 # true
    else
        # Does not exist
        return 1 # false
    fi
}
export -f checkIfFileExists

# Check if Mac is Apple Silicon (otherwise Intel x86)
function checkIfAppleSilicion(){
    # Intel=x86_64 | AppleSilicon=arm64
    if uname -m | grep -q -w arm64; then
        return 0 # true
    else
        return 1 # false
    fi
}
export -f checkIfAppleSilicion

# Check if Mac is portable
# (MacBook, MacBook Air, MacBook Pro)
function checkIfMacIsPortable(){
    if system_profiler -detailLevel mini SPHardwareDataType | grep -q Book; then
        return 0 # true
    else
        return 1 # false
    fi
}
export -f checkIfMacIsPortable

# Check if Xcode Command Line Tools are installed
function checkIfXcodeInstalled(){
    local XcodeCLTinstallPath="/Library/Developer/CommandLineTools"
    if [ "$(xcode-select -p)" != "$XcodeCLTinstallPath" ]; then
        # Not installed
        return 1 # false
    else
        # Installed
        return 0 # true
    fi
}
export -f checkIfXcodeInstalled

# Check if Homebrew is installed
function checkIfHomebrewInstalled(){
    local HomebrewInstallPath="/opt/homebrew/bin/brew"
    if ! command -v brew &> /dev/null || [ "$(command -v brew)" != "$HomebrewInstallPath" ]; then
        # Not installed
        return 1 # false
    else
        # Installed
        return 0 # true
    fi
}
export -f checkIfHomebrewInstalled

# Check if User has authenticated to App Store
function checkIfAppStoreAuthenticated(){
    if ! command -v mas &> /dev/null; then
        # Not authenticated
        return 1 # false
    else
        # Authenticated
        return 0 # true
    fi
}
export -f checkIfAppStoreAuthenticated

# Check if current User is in admin group
# Source: https://apple.stackexchange.com/a/179531/86244
function checkIfUserIsAdmin(){
    if groups $USER | grep -q -w admin; then
        # User is admin
        return 0 # true
    else
        # User is NOT admin
        return 1 # false
    fi
}
export -f checkIfUserIsAdmin

function macosGatekeeper(){
    if checkIfNotEmpty "$1"; then
        # --> Notify first
        notify
        # Requires Admin privileges
        if checkIfUserIsAdmin; then
            if [ "$1" = "on" ]; then
                # ENABLE Gatekeeper (Allow apps from "App Store and identified developers")
                sudo spctl --master-enable
            elif [ "$1" = "off" ]; then
                # DISABLE Gatekeeper (Allow apps from "Anywhere")
                sudo spctl --master-disable
            fi
        else
            showinfo "'spctl' requires root privileges. Run with an admin user, or using sudo." "error"
        fi
    else
        # Get current Gatekeeper status
        if spctl --status | grep -q -w enabled; then
            return 0 # enabled
        else
            return 1 # disabled
        fi
    fi
}
export -f macosGatekeeper

# Download a file from a given URL using curl
function downloadFromUrl(){
    # Check that the URL and destination file name are valid
    if checkIfNotEmpty "$1" && checkIfNotEmpty "$2"; then
        local downloadFolder="$HOME/Downloads/"
        local downloadPath="$downloadFolder$2"

        # Use curl to fetch the URL and store the resource
        #  -S = silent, but allow errors & progress bar
        #  -L = follow HTTP redirects
        #  -f = fail silently on server errors
        #  -# = show a progress bar (instead of a table)
        #  -A = use a custom User Agent string
        curl -SLf\# "$1" -o "$downloadPath" -A "macOS-scripted-setup/1.0 (compatible; +https://github.com/Swiss-Mac-User/macOS-scripted-setup)"
    else
        showinfo "Missing URL or download target path" "error"
    fi
}
export -f downloadFromUrl

# Unzip a ZIP-file in place
function unzipFile(){
    local downloadFolder="$HOME/Downloads/"
    local filePath="$downloadFolder$1"
    if checkIfFileExists "$filePath"; then
        unzip -qq "$filePath" -d "$downloadFolder"
    else
        showinfo "ZIP file not found:\n$filePath" "error"
    fi
}
export -f unzipFile

# Unmount a DMG-image and copy App to Downloads folder
function unmountFile(){
    local downloadFolder="$HOME/Downloads/"
    local filePath="$downloadFolder$1"
    if checkIfFileExists "$filePath" && checkIfNotEmpty "$2"; then
        local appFilename="$2.app"
        # --> Mount Volume
        hdiutil attach "$filePath" -quiet
        # --> Move to Applications (suppress errors)
        cp -r "/Volumes/$2/$2.app" "$downloadFolder"
        # --> Unmount Volume
        hdiutil unmount "/Volumes/$2" -force -quiet
    else
        showinfo "Missing file path or Application name" "error"
        return 1 # error
    fi
}
export -f unmountFile

# Move an Application to the User or System Applications folder
# (and optionally open it upon moving)
function moveApplication(){
    if checkIfNotEmpty "$1"; then
        local downloadedApplicationPath="$HOME/Downloads/$1"

        if checkIfFileExists "$downloadedApplicationPath"; then
            if checkIfFileExists "$HOME/Applications/"; then
                local ApplicationsDir="$HOME/Applications/"
            else
                local ApplicationsDir="/Applications/"
            fi

            # Disable Quarantine for App (not working on macOS 13+)
            #disableAppQuarantine "$downloadedApplicationPath"

            # Move the Application file
            mv "$downloadedApplicationPath" "$ApplicationsDir"

            # Open App, if required
            if checkIfNotEmpty "$2" && [ "$2" = "open" ]; then
                open -gj "$ApplicationsDir$1"
            fi
        else
            showinfo "Cannot move Application '$1'\nPath not found: $downloadedApplicationPath" "error"
            return 1 # error
        fi
    else
        showinfo "No Application name provided" "error"
        return 1 # error
    fi
}
export -f moveApplication

# Remove XProtect quarantine flags from a macOS File or Folder
function disableAppQuarantine(){
    if checkIfFileExists "$1"; then
        xattr -cr "$1"
    fi
}
export -f disableAppQuarantine
