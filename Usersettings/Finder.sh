#!/usr/bin/env zsh

# Apps, disable App Nap for all apps
function disableAppNap(){
    defaults write NSGlobalDomain "NSAppSleepDisabled" -bool TRUE
}
export -f disableAppNap

# File save, expand save panel by default
function expandAllSavePanels(){
    defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool TRUE
    defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode2" -bool TRUE
}
export -f expandAllSavePanels

# Print, expand print panel by default
function expandAllPrintPanels(){
    defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint" -bool TRUE
    defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint2" -bool TRUE
}
export -f expandAllPrintPanels

# File save, save to disk by default rather than to iCloud
function saveToDiskInsteadOfiCloud(){
    defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool FALSE
}
export -f saveToDiskInsteadOfiCloud

# Finder, show all filename extensions
function showAllFileExtensions(){
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool TRUE
}
export -f showAllFileExtensions

# Interface, action on double-clicking window
# Interface, miniaturise on double-click
function minimizeWindowsOnDoubleclick(){
    defaults write NSGlobalDomain "AppleActionOnDoubleClick" -string "Minimize"
    defaults write NSGlobalDomain "AppleMiniaturizeOnDoubleClick" -bool TRUE
}
export -f minimizeWindowsOnDoubleclick

# Interface, always show scrollbars
function alwaysShowScrollbars(){
    # Supported values: Automatic | Always | WhenScrolling
    defaults write NSGlobalDomain "AppleShowScrollBars" -string "WhenScrolling"
}
export -f alwaysShowScrollbars

# Interface, close always confirms changes
function alwaysConfirmClose(){
    defaults write NSGlobalDomain "NSCloseAlwaysConfirmsChanges" -bool TRUE
}
export -f alwaysConfirmClose

# Interface, disable ‘natural’ scrolling
function disableNaturalScrolling(){
    defaults write NSGlobalDomain "com.apple.swipescrolldirection" -bool FALSE
}
export -f disableNaturalScrolling

# Interface, disable menu bar transparency
function disableTransparencyAndTinting(){
    defaults write NSGlobalDomain "AppleEnableMenuBarTransparency" -bool FALSE
    defaults write NSGlobalDomain "AppleReduceDesktopTinting" -bool TRUE
}
export -f disableTransparencyAndTinting

# Contact names
function disableContactstNicknames(){
    defaults write NSGlobalDomain "NSPersonNameDefaultShouldPreferNicknamesPreference" -bool FALSE
}
export -f disableContactstNicknames

# Enable Fast User Switching
function enableFastUserSwitching(){
    defaults write NSGlobalDomain "userMenuExtraStyle" -int 2
}
export -f enableFastUserSwitching

# Interface, quit always saves windows
function alwaysSaveWindowstateOnQuit(){
    defaults write NSGlobalDomain "NSQuitAlwaysKeepsWindows" -bool TRUE
}
export -f alwaysSaveWindowstateOnQuit

# Interface, set sidebar icon size to small (medium = 2)
function useSmallIconsInSidebar(){
    defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int 1
}
export -f useSmallIconsInSidebar

# Disable creation of Metadata Files on Network Volumes (avoids creation of .DS_Store and AppleDouble ._ files.)
function disableMetadataFilesOnNetworkshares(){
    defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool TRUE
}
export -f disableMetadataFilesOnNetworkshares

# Disable creation of Metadata Files on USB Volumes (avoids creation of .DS_Store and AppleDouble ._ files.)
function disableMetadataFilesOnExternalDrives(){
    defaults write com.apple.desktopservices "DSDontWriteUSBStores" -bool TRUE
}
export -f disableMetadataFilesOnExternalDrives

# Finder: show status bar, and side bar, but hide path bar
function showStatusAndPathBars(){
    defaults write com.apple.finder "ShowStatusBar" -bool TRUE
    defaults write com.apple.finder "ShowSidebar" -bool TRUE
    defaults write com.apple.finder "ShowPathbar" -bool FALSE
}
export -f showStatusAndPathBars

# When performing a search, search the current folder by default
# (the default 'This Mac' is "SCev")
function defaultSearchCurrentFolder(){
    defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
}
export -f defaultSearchCurrentFolder

# Set User Home as the default location for new Finder windows
# (for other paths, use `PfLo` and `file:///full/path/here/`)
function defaultNewWindowLocation(){
    defaults write com.apple.finder "NewWindowTarget" -string "PfHm"
    defaults write com.apple.finder "NewWindowTargetPath" -string "file://${HOME}/"
}
export -f defaultNewWindowLocation

# Show icons for hard drives, servers, and removable media on the desktop
function showVolumeIconsOnDesktop(){
    defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool TRUE
    defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool TRUE
    defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool TRUE
    defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool TRUE
}
export -f showVolumeIconsOnDesktop

# Enable snap-to-grid for icons on the desktop and in other icon views
function enableSnapToGrid(){
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
}
export -f enableSnapToGrid

# Disable the warning before emptying the Trash
function disableEmptyTrashWarning(){
    defaults write com.apple.finder "WarnOnEmptyTrash" -bool FALSE
}
export -f disableEmptyTrashWarning

# Add Folder settings (.DS_Store files)
function updateApplicationsFolderListColumns(){
    if ! checkIfFileExists "$HOME/Applications/.DS_Store"; then
        touch "$HOME/Applications/.DS_Store"
    fi
    echo "^@^@^@^ABud1^@^@^X^@^@^@^H^@^@^@^X^@^@^@^P^K^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^H^@^@^@^H^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^$" > "$HOME/Applications/.DS_Store"
}
export -f updateApplicationsFolderListColumns

function restartFinder(){
	killall Finder
}
export -f restartFinder
