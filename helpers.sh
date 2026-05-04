#!/usr/bin/env zsh

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

# Ask user a yes/no question-prompt in the Terminal - and return 0 for yes, 1 for no
function ask() {
    local prompt="$1"
    local response

    while true; do
        read "response?$prompt (Y=yes/N=no): "
        case $response in
            [Yy]* ) return 0;; # Yes=true
            [Nn]* ) return 1;; # No=false
            * ) echo "Please answer Y (for YES) or N (for NO).";;
        esac
    done
}
export -f ask

# Return boolean config variable names from a config file
function get_boolean_config_names() {
    local source_config="$1"

    if ! checkIfFileExists "$source_config"; then
        return 1
    fi

    awk -F= '
        /^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=/ {
            key = $1
            value = $2
            sub(/[[:space:]]+$/, "", key)
            sub(/^[[:space:]]+/, "", value)
            sub(/[[:space:]]*(#.*)?$/, "", value)
            gsub(/[[:space:]]/, "", value)
            if (value == "true" || value == "false") {
                print key
            }
        }
    ' "$source_config"
}
export -f get_boolean_config_names

# Load and/or crate a re-run config file
function load_rerunconfig() {
    local source_config="$1"

    if checkIfFileExists "$rerunconfig" && [[ -s "$rerunconfig" ]]; then
        showinfo "Loaded a previous setup progress ($rerunconfig)" "confirm"
    else
        grep -v '^#' "$source_config" > "$rerunconfig"
        showinfo "Added a setup progress store based on $source_config" "confirm"
    fi
}
export -f load_rerunconfig

# Remove an existing re-run config file (after successful setup)
function discard_rerunconfig() {
    if checkIfFileExists "$rerunconfig"; then
        rm "$rerunconfig"
        showinfo "Removed the setup progress storage file (config.rerun.sh)" "note"
    fi
}
export -f discard_rerunconfig

# Merge progress from re-run config with master config
function set_installprogress() {
    local config_var="$1"
    local rerun_value
    local current_value

    # Read the value from the re-run config
    rerun_value=$(grep "^$config_var=" "$rerunconfig" | cut -d'=' -f2 | tr -d '"' | xargs)

    # If the value in the re-run config is false (= step already done), skip this install step
    if [[ "$rerun_value" == "false" ]]; then
        eval "current_value=\$$config_var"
        eval "$config_var=false"
        # Only report as "already done" if it was originally enabled in the loaded config
        # (skip silently when the user simply configured it as false from the start)
        if [[ "$current_value" == "true" ]]; then
            showinfo "'$config_var' already done - setup will skip it" "note"
        fi
    fi
}
export -f set_installprogress

# Store setup progress for re-runs
function storeprogress() {
    local installstep=$1
    local configfile=$2

    # Update progress in state file
    if checkIfNotEmpty "$installstep" && checkIfNotEmpty "$configfile"; then
        if checkIfFileExists "$configfile"; then
            sed -i '' "s/^$installstep=true/$installstep=false/" "$configfile"
        else
            showinfo "Cannot store setup progress in $configfile" "error"
        fi
    else
        showinfo "ABORTING SETUP: previous installation step failed. Try to re-run the setup." "shout"
        exit 1 # STOP SETUP
    fi
}
export -f storeprogress

# Check if Mac is Apple Silicon (otherwise Intel x86)
function checkIfAppleSilicon(){
    # Intel=x86_64 | AppleSilicon=arm64
    if uname -m | grep -q -w arm64; then
        return 0 # true
    else
        return 1 # false
    fi
}
export -f checkIfAppleSilicon

# Check if Mac is portable
# (MacBook, MacBook Air, MacBook Pro)
function checkIfMacIsPortable(){
    if system_profiler -detailLevel mini SPHardwareDataType 2>/dev/null | grep -q MacBook; then
        return 0 # true
    else
        return 1 # false
    fi
}
export -f checkIfMacIsPortable

# Get logged-in user's Username
function getUsername(){
    local username="$(id -un)"
    echo "$username"
    return 0
}
export -f getUsername

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
        # --> Copy to Downloads
        ditto "/Volumes/$2/$appFilename" "$downloadFolder$appFilename"
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
