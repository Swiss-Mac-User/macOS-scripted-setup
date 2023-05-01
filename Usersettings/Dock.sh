#!/usr/bin/env zsh

# -- Dock settings --
# --> Auto-hide the Dock
function autohideDock(){
    defaults write com.apple.dock "autohide" -bool TRUE
}
export -f autohideDock

# --> Faster Dock show/hide
function speedupDock(){
    defaults write com.apple.dock "mineffect" -string "suck"
    defaults write com.apple.dock "autohide-delay" -float 0
    defaults write com.apple.dock "autohide-time-modifier" -float 0.8
}
export -f speedupDock

# --> Hide recent Applications
function noRecentAppsInDock(){
    defaults write com.apple.dock "show-recents" -bool FALSE
}
export -f noRecentAppsInDock

# --> Dim hidden Apps
function dimHiddenAppsInDock(){
    defaults write com.apple.dock "showhidden" -bool TRUE
}
export -f dimHiddenAppsInDock

# --> Show indicator for running Apps
function indicateRunningAppsInDock(){
    if checkIfNotEmpty "$1" && "$1" == FALSE; then
        local value=FALSE
    else
        local value=TRUE
    fi
    defaults write com.apple.dock "show-process-indicators" -bool "$value"
}
export -f indicateRunningAppsInDock

# --> Show only running Apps in Dock
# Source: https://www.macrumors.com/how-to/macos-dock-show-active-apps/
function showOnlyRunningAppsInDock(){
    defaults write com.apple.dock "static-only" -bool TRUE

    # Disable indicators for running Apps (not needed for dynamic Dock)
    indicateRunningAppsInDock FALSE
}
export -f showOnlyRunningAppsInDock

# Add an Application to the macOS Dock
# - usage: addAppToDock "[Application Name]"
# - example: addAppToDock "Terminal"
# Source: https://github.com/rpavlick/add_to_dock
function addAppToDock() {
    local app_name="$1"
    local launchservices_path="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
    local app_path=$($launchservices_path -dump | grep -o "/.*$app_name.app" | grep -v -E "Backups|Caches|TimeMachine|Temporary|/Volumes/$app_name" | uniq | sort | head -n1)
    if open -Ra "$app_path"; then
       defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    else
       showinfo "Application not found: $1\n$app_path" "error"
    fi
}
export -f addAppToDock

# Add an empty space to the macOS Dock
# Source: https://github.com/rpavlick/add_to_dock
function addSpacerToDock() {
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}
export -f addSpacerToDock

# Remove all persistent App Icons from the macOS Dock
# Source: https://github.com/rpavlick/add_to_dock
function clearDock() {
    defaults write com.apple.dock persistent-apps -array
}
export -f clearDock

# Reset the macOS Dock to Apple's default settings
function resetDock() {
    defaults write com.apple.dock; killall Dock
}
export -f resetDock

# --> Restart the Dock process
function restartDock(){
    killall Dock
}
export -f restartDock
