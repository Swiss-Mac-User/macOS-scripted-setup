#!/usr/bin/env zsh

# Hide Spotlight tray-icon (and subsequent helper)
function hideSpotlightFromMenubar(){
    #sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
    # !! Command does not work under macOS 13.0 Ventura
}
export -f hideSpotlightFromMenubar

# Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before.
function disableSpotlightIndexingExternalDrives(){
    #sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
    # !! Command does not work under macOS 13.0 Ventura

    # --> Other options
    # Stop indexing any volume (including the macOS Harddrive).
    #sudo mdutil -a -i off
    # Add the macOS Harddrive back to being indexed by Spotlight
    #sudo mdutil -i on /Volumes/Macintosh\ HD
}
export -f disableSpotlightIndexingExternalDrives

# Change indexing order and disable some search results
function disableSpotlightSearchItems(){
    # --> Some things are just not needed to be searched for...
    defaults write com.apple.spotlight orderedItems -array \
        '{"enabled" = 1;"name" = "APPLICATIONS";}' \
        '{"enabled" = 1;"name" = "CONTACT";}' \
        '{"enabled" = 1;"name" = "DIRECTORIES";}' \
        '{"enabled" = 1;"name" = "DOCUMENTS";}' \
        '{"enabled" = 1;"name" = "IMAGES";}' \
        '{"enabled" = 1;"name" = "PDF";}' \
        '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
        '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
        '{"enabled" = 1;"name" = "SOURCE";}' \
        '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
        '{"enabled" = 1;"name" = "MENU_OTHER";}' \
        '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
        '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
        '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
        '{"enabled" = 0;"name" = "FONTS";}' \
        '{"enabled" = 0;"name" = "MESSAGES";}' \
        '{"enabled" = 0;"name" = "EVENT_TODO";}' \
        '{"enabled" = 0;"name" = "BOOKMARKS";}' \
        '{"enabled" = 0;"name" = "MUSIC";}' \
        '{"enabled" = 0;"name" = "MOVIES";}' \
        '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
        '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

    # Load new settings before rebuilding the index
    killall mds > /dev/null 2>&1

    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        # Make sure indexing is enabled for the main volume
        sudo mdutil -i on / > /dev/null
        # Rebuild the index from scratch
        sudo mdutil -E / > /dev/null
    else
        showinfo "'mdutil' requires root privileges. Run with an admin user, or using sudo." "error"
    fi
}
export -f disableSpotlightSearchItems
