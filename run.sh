#!/usr/bin/env zsh

# Get the macOS Scripted Setup directory root
SCRIPT_DIR="${0:A:h}"

# ------------------------------
#       PRE-FLIGHT CHECKS
# ------------------------------
# Syntax-check all scripts before sourcing anything.
# Aborts immediately on the first parse error found.
for _check_file in \
    "$SCRIPT_DIR/helpers.sh" \
    "$SCRIPT_DIR"/Systemservices/*.sh \
    "$SCRIPT_DIR"/Usersettings/*.sh \
    "$SCRIPT_DIR"/FilesFolders/*.sh \
    "$SCRIPT_DIR"/Applications/*.sh; do
    [[ -r "$_check_file" ]] || continue
    if ! zsh -n "$_check_file" 2>&1; then
        echo "\n❌ ABORTING SETUP: Syntax error in '$_check_file' — fix it before running setup." >&2
        exit 1
    fi
done
unset _check_file


# ------------------------------
#          INITIALIZE
# ------------------------------
# Load Helper functions persistently
source "$SCRIPT_DIR/helpers.sh" > /dev/null

# Initialize configs and a temporary configuration store
defaultconfig="$SCRIPT_DIR/config.default.sh"
customconfig="$SCRIPT_DIR/config.sh"
rerunconfig="$SCRIPT_DIR/config.rerun.sh"
loadedconfig=""

# Load the right configuration file
showinfo "Loading setup configuration" "shout"
if checkIfFileExists "$customconfig"; then
    # Load CUSTOM configs
    source "$customconfig" > /dev/null
    showinfo "Loaded custom configs ($customconfig)" "confirm"
    loadedconfig="$customconfig"
elif checkIfFileExists "$defaultconfig"; then
    # Fallback: Load DEFAULT configs
    source "$defaultconfig" > /dev/null
    showinfo "Loaded default configs ($defaultconfig)" "confirm"
    loadedconfig="$defaultconfig"
else
    # EXIT if no valid configs found
    showinfo "ABORTING SETUP: no valid config file found ($customconfig or $defaultconfig)" "shout"
    exit 1
fi

# Check for previous setup progress in config.rerun.sh
if checkIfFileExists "$rerunconfig" && [[ -s "$rerunconfig" ]]; then
    showinfo "Found previous setup progress ($rerunconfig)" "confirm"
    if ask "Continue from previous setup progress?"; then
        # Merge loaded configs with previous progress
        for configsetting in $(get_boolean_config_names "$rerunconfig"); do
            set_installprogress "$configsetting"
        done
        showinfo "Merged setup configurations with previous progress ($rerunconfig)" "note"
    else
        # Discard old progress and start fresh
        discard_rerunconfig
        load_rerunconfig "$loadedconfig"
        showinfo "STARTING FRESH SETUP (previous progress discarded)" "note"
    fi
else
    # No previous progress: create new rerun config
    load_rerunconfig "$loadedconfig"
    showinfo "STARTING NEW SETUP" "note"
fi
unset loadedconfig


# ------------------------------
#   SETUP MACOS SYSTEM SERVICES
# ------------------------------
showinfo "SETUP MACOS SYSTEM SERVICES" "shout"
for service in "$SCRIPT_DIR"/Systemservices/*.sh; do
    [ -r "$service" ] && source "$service" > /dev/null
done
unset service
# -- FileVault2 --
if [ "$useFileVault" = true ]; then
    showinfo "Enabling FileVault:" "note"
    enableFileVault
    showinfo "" "confirm"
    storeprogress "useFileVault" "$rerunconfig"
fi
# -- Built-in Firewall --
if [ "$enableFirewall" = true ]; then
    showinfo "Enabling Firewall Stealthmode:" "note"
    activateFirewallStealthmode
    showinfo "" "confirm"
    showinfo "Enabling Firewall:" "note"
    enableFirewall
    showinfo "" "confirm"
    storeprogress "enableFirewall" "$rerunconfig"
fi
# -- Time Machine --
if [ "$speedupTimemachine" = true ]; then
    showinfo "Disabling Time Machine prompts for new connected drives:" "note"
    muteTimeMachine
    showinfo "" "confirm"
    showinfo "Throttling Time Machine process priority:" "note"
    speedupTimeMachine
    showinfo "" "confirm"
    storeprogress "speedupTimemachine" "$rerunconfig"
fi
# -- AirDrop --
if [ "$enableWiredAirDrop" = true ]; then
    showinfo "Enabling AirDrop through Ethernet:" "note"
    enableAirDropOnEthernet
    showinfo "" "confirm"
    storeprogress "enableWiredAirDrop" "$rerunconfig"
fi
# -- Login and Password --
if [ "$disableShutdownRestartInLogin" = true ]; then
    showinfo "Disabling 'Shutdown' button on Login window:" "note"
    disableShutdownOnLogin
    showinfo "" "confirm"
    showinfo "Disabling 'Restart' button on Login window:" "note"
    disableRestartOnLogin
    showinfo "" "confirm"
    storeprogress "disableShutdownRestartInLogin" "$rerunconfig"
fi
if [ "$enableScreensaverPassword" = true ]; then
    showinfo "Enabling password prompt when interrupting Screensaver:" "note"
    enableUserpasswordOnScreensaver
    showinfo "" "confirm"
    storeprogress "enableScreensaverPassword" "$rerunconfig"
fi
if [ "$playMacStartupSound" = true ]; then
    showinfo "Enabling the iconic Startup Chime on your Mac:" "note"
    enableStartupChime
    showinfo "" "confirm"
    storeprogress "playMacStartupSound" "$rerunconfig"
fi
# -- OS updates --
if [ "$installSystemUpdates" = true ]; then
    showinfo "Checking for pending macOS Updates:" "note"
    getSoftwareUpdates
    showinfo "Installing available macOS System Software Updates:" "shout"
    installSoftwareUpdates
    showinfo "" "confirm"
    showinfo "Enabling scheduled future macOS System Software updates:" "note"
    enableSoftwareUpdateSchedule
    showinfo "" "confirm"
    storeprogress "installSystemUpdates" "$rerunconfig"
fi


# ------------------------------
#      APPLY USER SETTINGS
# ------------------------------
showinfo "APPLY USER SETTINGS" "shout"
for setting in "$SCRIPT_DIR"/Usersettings/*.sh; do
    [ -r "$setting" ] && source "$setting" > /dev/null
done
unset setting

# -- Application Performance --
if [ "$betterApplicationPerformance" = true ]; then
    showinfo "Disabling App Nap (application power saving):" "note"
    disableAppNap
    setActivityMonitorProcesslist
    showinfo "" "confirm"
    storeprogress "betterApplicationPerformance" "$rerunconfig"
fi

# -- macOS Layout --
if [ "$dateTimeInMenubar" = true ]; then
    showinfo "Setting analog Menu Clock:" "note"
    setReadableMenuclock
    showinfo "" "confirm"
    storeprogress "dateTimeInMenubar" "$rerunconfig"
fi
if [ "$showScrollbars" = true ]; then
    showinfo "Setting always visible Scrollbars:" "note"
    alwaysShowScrollbars
    showinfo "" "confirm"
    storeprogress "showScrollbars" "$rerunconfig"
fi
if [ "$disableNaturalScrolling" = true ]; then
    showinfo "Disabling Natural Scrolling:" "note"
    disableNaturalScrolling
    showinfo "" "confirm"
    storeprogress "disableNaturalScrolling" "$rerunconfig"
fi
if [ "$disableTransparency" = true ]; then
    showinfo "Disabling transparencies and tinting (windows, menubar):" "note"
    disableTransparencyAndTinting
    showinfo "" "confirm"
    storeprogress "disableTransparency" "$rerunconfig"
fi
if [ "$useRealNamesForContacts" = true ]; then
    showinfo "Enable using real names for Contacts (instead of Nicknames):" "note"
    disableContactstNicknames
    showinfo "" "confirm"
    storeprogress "useRealNamesForContacts" "$rerunconfig"
fi

# -- Mission Control --
if [ "$useMissionControl" = true ]; then
    showinfo "Configuring Mission Control:" "note"
    setMissionControlHotCorners
    groupMissionControlByApplication
    switchMissionControlSpacesByApplication
    useMissionControlSpacePerDisplay
    showinfo "" "confirm"
    storeprogress "useMissionControl" "$rerunconfig"
fi

# -- Control Centre --
if [ "$enableFastUserswitching" = true ]; then
    showinfo "Enabling Fast User Switching:" "note"
    enableFastUserSwitching
    showFastUserSwitching
    showinfo "" "confirm"
    storeprogress "enableFastUserswitching" "$rerunconfig"
fi
if [ "$showBatteryPercentage" = true ] && checkIfMacIsPortable; then
    showinfo "Show Battery %-Percentage:" "note"
    showBatteryPercentage
    showinfo "" "confirm"
    storeprogress "showBatteryPercentage" "$rerunconfig"
fi

# -- macOS Text / Keyboard Input --
if [ "$disableAnnoyingTextcorrections" = true ]; then
    showinfo "Disabling annoying automatic Text corrections:" "note"
    disableTextAutocorrect
    disableTextCapitalisation
    disableTextPeriodSubstitution
    showinfo "" "confirm"
    storeprogress "disableAnnoyingTextcorrections" "$rerunconfig"
fi
if [ "$enableTrackpadClicks" = true ] && checkIfMacIsPortable; then
    showinfo "Enable Tap to Click on the Trackpad:" "note"
    enableTrackpadClicking
    showinfo "" "confirm"
    storeprogress "enableTrackpadClicks" "$rerunconfig"
fi
if [ "$fasterMouseCursor" = true ]; then
    showinfo "Speedup Cursor on Trackpads and Mouses:" "note"
    increaseMouseSpeed
    showinfo "" "confirm"
    storeprogress "fasterMouseCursor" "$rerunconfig"
fi
if [ "$fnKeyFunction" != 'off' ] && [ "$fnKeyFunction" != false ]; then
    showinfo "Changing fn 🌐 key functionality:" "note"
    useFnKeyFor "$fnKeyFunction"
    showinfo "" "confirm"
    storeprogress "fnKeyFunction" "$rerunconfig"
fi
if [ "$enableTabFocusChange" = true ]; then
    showinfo "Use Tab key for focus changes:" "note"
    useTabForElementFocus
    showinfo "" "confirm"
    storeprogress "enableTabFocusChange" "$rerunconfig"
fi
if [ "$disableDoubleSpacePeriod" = true ]; then
    showinfo "Do not insert a period when pressing space twice:" "note"
    disablePeriodSubstitution
    showinfo "" "confirm"
    storeprogress "disableDoubleSpacePeriod" "$rerunconfig"
fi

# -- Dock --
if [ "$speedupDock" = true ]; then
    showinfo "Enabling auto-hiding the Dock:" "note"
    autohideDock
    showinfo "" "confirm"
    showinfo "Making the Dock hide/show much snappier:" "note"
    speedupDock
    showinfo "" "confirm"
    storeprogress "speedupDock" "$rerunconfig"
fi
if [ "$beautifyDock" = true ]; then
    showinfo "Remove all default App Icons from the Dock:" "note"
    clearDock
    showinfo "" "confirm"
    showinfo "Disabling recent Apps from the Dock:" "note"
    noRecentAppsInDock
    showinfo "" "confirm"
    showinfo "Enabling dimming hidden Apps in the Dock:" "note"
    dimHiddenAppsInDock
    indicateRunningAppsInDock
    showinfo "" "confirm"
    storeprogress "beautifyDock" "$rerunconfig"
fi
if [ "$minimalDock" = true ]; then
    showinfo "Showing only active Apps in the Dock:" "note"
    showOnlyRunningAppsInDock
    showinfo "" "confirm"
    storeprogress "minimalDock" "$rerunconfig"
fi
restartDock

# -- Displays --
if [ "$enableAllResolutions" = true ]; then
    showinfo "Expanding Displays resolutions-list to show all entries:" "note"
    showAllDisplayResolutions
    showinfo "" "confirm"
    storeprogress "enableAllResolutions" "$rerunconfig"
fi

# -- Finder --
if [ "$customizeFinder" = true ]; then
    showinfo "Customizing the macOS Finder:" "notice"

    # --> Photos handling when Apple Devices connected
    showinfo "Disabling auto-import of Photos (from connected Apple Devices):" "note"
    preventAutoImportPhotos
    showinfo "" "confirm"

    # -- Finder windows & folders --
    showinfo "Improving Finder windows and dialogues:" "note"
    disableMetadataFilesOnNetworkshares
    disableMetadataFilesOnExternalDrives
    saveToDiskInsteadOfiCloud
    expandAllSavePanels
    expandAllPrintPanels
    minimizeWindowsOnDoubleclick
    alwaysConfirmClose
    disableEmptyTrashWarning
    alwaysSaveWindowstateOnQuit
    useSmallIconsInSidebar
    showStatusAndPathBars
    defaultSearchCurrentFolder
    defaultNewWindowLocation
    showVolumeIconsOnDesktop
    enableSnapToGrid
    if [ "$showFileExtensions" = true ]; then
        showinfo "Showing all file extensions:" "note"
        showAllFileExtensions
        storeprogress "showFileExtensions" "$rerunconfig"
    fi
    if [ "$enableFullDraggableWindows" = true ]; then
        showinfo "Making all windows fully draggable using ⌘Command+^Control+Click:" "note"
        enableFullWindowDragzone
        storeprogress "enableFullDraggableWindows" "$rerunconfig"
    fi
    if [ "$removeTrashbinItemsPeriodically" = true ]; then
        showinfo "Trash bin: automatically remove items after 30 days:" "note"
        enableTrashAutoremove30days
        storeprogress "removeTrashbinItemsPeriodically" "$rerunconfig"
    fi
    showinfo "" "confirm"

    # --> Screenshots
    showinfo "Improving Screenshots:" "note"
    saveScreenshotsAs "$useScreenshotsFormat"
    if [ "$useScreenshotsNumericFilename" = true ]; then
        useNumericScreenshots
        storeprogress "useScreenshotsNumericFilename" "$rerunconfig"
    fi
    showinfo "" "confirm"

    # --> Text Edit
    showinfo "Setting Text Edit default document format to Plain-Text:" "note"
    enableTextEditPlaintext
    showinfo "" "confirm"

    # --> Spotlight
    showinfo "Improving Spotlight:" "note"
    hideSpotlightFromMenubar
    disableSpotlightIndexingExternalDrives
    disableSpotlightSearchItems
    showinfo "" "confirm"

    showinfo "Restarting Finder and SystemUIServer service:" "note"
    restartSystemUIServer
    restartFinder
    showinfo "" "confirm"

    storeprogress "customizeFinder" "$rerunconfig"
fi
# -- Apple Apps --
if [ "$showMusicNextSongPlaying" = true ]; then
    showinfo "Show «Playing next» notification from Music App:" "note"
    showNextSongNotification
    showinfo "" "confirm"
    storeprogress "showMusicNextSongPlaying" "$rerunconfig"
fi
if [ "$showSubjectInMessagesApp" = true ]; then
    showinfo "Show the Subject field in Messages App:" "note"
    enableMessagesSubjectField
    showinfo "" "confirm"
    storeprogress "showSubjectInMessagesApp" "$rerunconfig"
fi

# -- Safari --
if [ "$secureSafariBrowser" = true ]; then
    showinfo "More Privacy and Security for Safari:" "notice"
    # DEPRECATED Settings:
    # --> Private
    #showinfo "Enabling Private Search and No Tracking:" "note"
    #privateSearchQueriesInSafari
    #noContentTrackingInSafari
    #showinfo "" "confirm"
    # --> Security
    #showinfo "Enabling all Security features in Safari:" "note"
    #showFullUrlInSafari
    #preventUnpackingDownloadedFilesInSafari
    #preventVisitingBadWebsitesInSafari
    #preventOutdatedExtensionsInSafari
    #preventAutofillingYourDataInSafari
    showinfo "Enabling Developer Tools in Safari:" "note"
    enableDeveloperToolsInSafari
    showinfo "" "confirm"
    storeprogress "secureSafariBrowser" "$rerunconfig"
fi

# -- Userhome Files + Folders --
for filesetting in "$SCRIPT_DIR"/FilesFolders/*.sh; do
    [ -r "$filesetting" ] && source "$filesetting" > /dev/null
done
unset filesetting
showinfo "CREATING ADDITIONAL FOLDERS AND FILES" "shout"
# --> ZSH profile configuration file
showinfo "Adding a ~/.zprofile ZSH Shell config file to userhome:" "note"
createUserFileZprofile
showinfo "" "confirm"
# --> Library folder
if [ "$showLibraryFolder" = true ]; then
    showinfo "Making the ~/Library folder in userhome visible:" "note"
    showUserhomeLibraryFolder
    showinfo "" "confirm"
    storeprogress "showLibraryFolder" "$rerunconfig"
fi
# --> Applications
if [ "$addUserApplicationsFolder" = true ]; then
    showinfo "Adding a ~/Applications folder to userhome:" "note"
    createUserFolderApplications
    updateApplicationsFolderListColumns
    showinfo "" "confirm"
    storeprogress "addUserApplicationsFolder" "$rerunconfig"
fi
# --> Sites
if [ "$addUserWebsitesFolder" = true ]; then
    showinfo "Adding a ~/Sites folder to userhome:" "note"
    createUserFolderSites
    showinfo "" "confirm"
    storeprogress "addUserWebsitesFolder" "$rerunconfig"
fi
# --> Games
if [ "$addUserGamesFolder" = true ]; then
    showinfo "Adding a ~/Games folder to userhome:" "note"
    createUserFolderGames
    showinfo "" "confirm"
    storeprogress "addUserGamesFolder" "$rerunconfig"
fi
# --> Desktop Pictures
if [ "$downloadWallpapers" = true ]; then
    showinfo "Adding Desktop Pictures folder to userhome ~/Pictures/:" "note"
    createUserFolderDesktopPictures
    showinfo "" "confirm"

    if [ "$dynamicWallpaperDesert" = true ]; then
        downloadWallpaperDesert
        storeprogress "dynamicWallpaperDesert" "$rerunconfig"
    fi
    if [ "$dynamicWallpaperExodus" = true ]; then
        downloadWallpaperExodus
        storeprogress "dynamicWallpaperExodus" "$rerunconfig"
    fi
    if [ "$dynamicWallpaperFluted" = true ]; then
        downloadWallpaperFluted
        storeprogress "dynamicWallpaperFluted" "$rerunconfig"
    fi
    if [ "$dynamicWallpaperFuji" = true ]; then
        downloadWallpaperFuji
        storeprogress "dynamicWallpaperFuji" "$rerunconfig"
    fi
    if [ "$dynamicWallpaperHivemind" = true ]; then
        downloadWallpaperHivemind
        storeprogress "dynamicWallpaperHivemind" "$rerunconfig"
    fi
    showinfo "" "confirm"
    storeprogress "downloadWallpapers" "$rerunconfig"
fi



# ------------------------------
#   APPLICATION INSTALLATIONS
#
# Note:
# open -g Do not bring the application to the foreground.
#      -j Launches the app hidden.
# ------------------------------
showinfo "APPLICATION INSTALLATIONS" "shout"
for app in "$SCRIPT_DIR"/Applications/*.sh; do
    [ -r "$app" ] && source "$app" > /dev/null
done
unset app
# -- DISABLE macOS Gatekeepr (if enabled) --
if macosGatekeeper; then
    showinfo "DISABLING Gatekeeper to allow unsiged Applications:" "note"
    macosGatekeeper "off"
    showinfo "" "confirm"
fi
# -- REMOVE pre-installed large Apps --
if [ "$removeGarageband" = true ]; then
    showinfo "Removing Garageband App:" "note"
    removeAppGarageband
    showinfo "(removed if present)" "confirm"
    storeprogress "removeGarageband" "$rerunconfig"
fi
if [ "$removeiMovie" = true ]; then
    showinfo "Removing iMovie App:" "note"
    removeAppiMovie
    showinfo "(removed if present)" "confirm"
    storeprogress "removeiMovie" "$rerunconfig"
fi
# -- Rosetta for macOS --
if [ "$installRosetta" = true ]; then
    showinfo "Installing Rosetta:" "note"
    installAppRosetta
    showinfo "" "confirm"
    storeprogress "installRosetta" "$rerunconfig"
fi
# -- Keka.app --
if [ "$installKeka" = true ]; then
    showinfo "Installing Keka:" "note"
    installAppKeka
    showinfo "" "confirm"
    storeprogress "installKeka" "$rerunconfig"
fi
# -- 1Password.app --
if [ "$install1Password" = true ]; then
    showinfo "Installing 1Password:" "note"
    installApp1Password
    showinfo "" "confirm"
    storeprogress "install1Password" "$rerunconfig"
fi
# -- AlDente.app (only on portable Macs) --
if [ "$installAlDente" = true ] && checkIfMacIsPortable; then
    showinfo "Installing AlDente:" "note"
    installAppAlDente
    showinfo "" "confirm"
    storeprogress "installAlDente" "$rerunconfig"
fi
# -- Beyond Compare --
if [ "$installBeyondCompare" = true ]; then
    showinfo "Installing Beyond Compare:" "note"
    installAppBeyondCompare
    showinfo "" "confirm"
    storeprogress "installBeyondCompare" "$rerunconfig"
fi
# -- Brave Browser --
if [ "$installBraveBrowser" = true ]; then
    showinfo "Installing Brave Browser:" "note"
    installAppBraveBrowser
    showinfo "" "confirm"
    storeprogress "installBraveBrowser" "$rerunconfig"
fi
# -- Discord.app --
if [ "$installDiscord" = true ]; then
    showinfo "Installing Discord:" "note"
    installAppDiscord
    showinfo "" "confirm"
    storeprogress "installDiscord" "$rerunconfig"
fi
# -- eqMac.app --
if [ "$installEqMac" = true ]; then
    showinfo "Installing eqMac:" "note"
    installAppEqMac
    showinfo "" "confirm"
    storeprogress "installEqMac" "$rerunconfig"
fi
# -- Figma.app --
if [ "$installFigma" = true ]; then
    showinfo "Installing Figma Desktop:" "note"
    installAppFigma
    showinfo "" "confirm"
    storeprogress "installFigma" "$rerunconfig"
fi
# -- Mozilla Firefox.app --
if [ "$installFirefoxBrowser" = true ]; then
    showinfo "Installing Firefox Browser:" "note"
    installAppFirefox
    showinfo "" "confirm"
    storeprogress "installFirefoxBrowser" "$rerunconfig"
fi
# -- Fork.app --
if [ "$installFork" = true ]; then
    showinfo "Installing Fork App:" "note"
    installAppFork
    showinfo "" "confirm"
    storeprogress "installFork" "$rerunconfig"
fi
# -- Google Chrome.app --
if [ "$installGoogleChromeBrowser" = true ]; then
    showinfo "Installing Google Chrome Browser:" "note"
    installAppGoogleChrome
    showinfo "" "confirm"
    storeprogress "installGoogleChromeBrowser" "$rerunconfig"
fi
# -- GrandPerspective.app --
if [ "$installGrandPerspective" = true ]; then
    showinfo "Installing GrandPerspective:" "note"
    installAppGrandPerspective
    showinfo "" "confirm"
    storeprogress "installGrandPerspective" "$rerunconfig"
fi
# -- Halloy IRC Client --
if [ "$installHalloyIRC" = true ]; then
    showinfo "Installing Halloy IRC Client:" "note"
    installAppHalloy
    showinfo "" "confirm"
    storeprogress "installHalloyIRC" "$rerunconfig"
fi
# -- Heroic Games Launcher --
if [ "$installHeroicGamesLauncher" = true ]; then
    showinfo "Installing Heroic Games Launcher:" "note"
    installAppHeroicGamesLauncher
    showinfo "" "confirm"
    storeprogress "installHeroicGamesLauncher" "$rerunconfig"
fi
# -- LinearMouse.app --
if [ "$installLinearMouse" = true ]; then
    showinfo "Installing LinearMouse:" "note"
    installAppLinearMouse
    showinfo "Disabling Mouse cursor acceleration of macOS:" "note"
    disableMouseAcceleration
    showinfo "" "confirm"
    storeprogress "installLinearMouse" "$rerunconfig"
fi
# -- Macs Fan Control.app --
if [ "$installMacsFanControl" = true ]; then
    showinfo "Installing Macs Fan Control:" "note"
    installAppMacsFanControl
    showinfo "" "confirm"
    storeprogress "installMacsFanControl" "$rerunconfig"
fi
# -- Microsoft Office / Office 365 for Mac --
if [ "$installMicrosoftOffice" = true ]; then
    showinfo "Installing Microsoft Office for Mac:" "note"
    installAppMicrosoftOffice
    showinfo "" "confirm"
    storeprogress "installMicrosoftOffice" "$rerunconfig"
fi
# -- Notion.app --
if [ "$installNotion" = true ]; then
    showinfo "Installing Notion App:" "note"
    installAppNotion
    showinfo "" "confirm"
    storeprogress "installNotion" "$rerunconfig"
fi
# -- Nova.app --
if [ "$installNova" = true ]; then
    showinfo "Installing Nova App:" "note"
    installAppNova
    showinfo "" "confirm"
    storeprogress "installNova" "$rerunconfig"
fi
# -- OverSight.app --
if [ "$installOverSight" = true ]; then
    showinfo "Installing OverSight:" "note"
    installAppOverSight
    showinfo "" "confirm"
    storeprogress "installOverSight" "$rerunconfig"
fi
# -- Sentinel.app --
if [ "$installSentinel" = true ]; then
    showinfo "Installing Sentinel:" "note"
    installAppSentinel
    showinfo "" "confirm"
    showinfo "If downloaded Apps cannot be opened: drag'n'drop them onto the Sentinel.app!" "shout"
    storeprogress "installSentinel" "$rerunconfig"
fi
# -- Spotify.app --
if [ "$installSpotify" = true ]; then
    showinfo "Installing Spotify:" "note"
    installAppSpotify
    showinfo "" "confirm"
    storeprogress "installSpotify" "$rerunconfig"
fi
# -- Steam --
if [ "$installSteam" = true ]; then
    showinfo "Installing Steam:" "note"
    installAppSteam
    showinfo "" "confirm"
    storeprogress "installSteam" "$rerunconfig"
fi
# -- Telegram.app --
if [ "$installTelegram" = true ]; then
    showinfo "Installing Telegram:" "note"
    installAppTelegram
    showinfo "" "confirm"
    storeprogress "installTelegram" "$rerunconfig"
fi
# -- Transmission.app --
if [ "$installTransmission" = true ]; then
    showinfo "Installing Transmission:" "note"
    installAppTransmission
    showinfo "" "confirm"
    storeprogress "installTransmission" "$rerunconfig"
fi
# -- Tresorit.app --
if [ "$installTresorit" = true ]; then
    showinfo "Installing Tresorit:" "note"
    installAppTresorit
    showinfo "" "confirm"
    storeprogress "installTresorit" "$rerunconfig"
fi
# -- Visual Studio Code --
if [ "$installVisualStudioCode" = true ]; then
    showinfo "Installing Visual Studio Code:" "note"
    installAppVSCode
    showinfo "" "confirm"
    storeprogress "installVisualStudioCode" "$rerunconfig"
fi
# -- VLC Media Player --
if [ "$installVLC" = true ]; then
    showinfo "Installing VLC Media Player:" "note"
    installAppVLC
    showinfo "" "confirm"
    storeprogress "installVLC" "$rerunconfig"
fi
# -- Warp --
if [ "$installWarp" = true ]; then
    showinfo "Installing Warp Terminal:" "note"
    installAppWarp
    showinfo "" "confirm"
    storeprogress "installWarp" "$rerunconfig"
fi
# -- Xnapper.app --
if [ "$installXnapper" = true ]; then
    showinfo "Installing Xnapper:" "note"
    installAppXnapper
    showinfo "" "confirm"
    storeprogress "installXnapper" "$rerunconfig"
fi
# -- Xcode Command Line Tools --
# !! NOTE: Pre-requisite for Homebrew and Git !!
if [ "$installXcodeTools" = true ] || [ "$installHomebrew" = true ]; then
    showinfo "Installing Xcode Command Line Tools (xcode):" "note"
    if checkIfXcodeInstalled; then
        installAppXcodeCLT
        # Retrying if Xcode CLT are installed, as installer may first need to do that
        if checkIfXcodeInstalled; then
            storeprogress "installXcodeTools" "$rerunconfig"
        fi
    else
        showinfo "Xcode Command Line Tools were not installed" "error"
    fi
fi
# -- Homebrew --
if [ "$installHomebrew" = true ]; then
    showinfo "Installing Homebrew (brew):" "note"

    # --> Check for Xcode CLT
    # !! NOTE: Pre-requisite for Homebrew !!
    if checkIfXcodeInstalled; then
        installAppHomebrew
    fi

    # Extend macOS Functionality with helpful Tools
    if checkIfHomebrewInstalled; then
        showinfo "" "confirm"
        storeprogress "installHomebrew" "$rerunconfig"

        # -- Install Apps via Homebrew --
        showinfo "Installing GnuPG, OpenSSH, and wget:" "note"
        brewinstallAppGnuPG
        brewinstallAppOpenSSH
        brewinstallAppWget
        showinfo "" "confirm"

        # --> QuickLook Extensions
        if [ "$installQuickLookPlugins" = true ]; then
            showinfo "Installing QuickLook Plugins for Finder:" "note"
            brewinstallAppApparency
            brewinstallAppFlux
            brewinstallAppSyntaxHighlight
            showinfo "" "confirm"
            storeprogress "installQuickLookPlugins" "$rerunconfig"
        fi

        # -- Night Shift (depends on Homebrew `nightlight` App) --
        if [ "$enableNightShift" = true ]; then
            showinfo "Enabling Night Shift with Sunset to Sunrise schedule:" "note"
            brewinstallAppNightlight
            showinfo "" "confirm"
            storeprogress "enableNightShift" "$rerunconfig"
        fi

        # -- Install Apps from App Store --
        if [ "$installAppStoreApps" = true ]; then
            # --> Mac App Store CLI
            showinfo "Installing Mac App Store CLI (mas):" "note"
            brewinstallAppMacAppStoreCLI

            # Continue only when successfully authenticated in App Store
            if checkIfAppStoreAuthenticated; then
                showinfo "" "confirm"

                # --> App updates from App Store
                showinfo "Activating Auto-Updating Apps:" "note"
                masinstallAppUpdates
                showinfo "" "confirm"

                # --> 1Password for Safari
                if [ "$install1Password" = true ]; then
                    masinstallApp1PasswordSafariExtension
                    storeprogress "install1Password" "$rerunconfig"
                fi

                # --> AdGuard for Safari
                if [ "$installAdGuardSafari" = true ]; then
                    masinstallAppAdGuardSafariExtension
                    storeprogress "installAdGuardSafari" "$rerunconfig"
                fi

                # -- Boop.app --
                if [ "$installBoop" = true ]; then
                    masinstallAppBoop
                    storeprogress "installBoop" "$rerunconfig"
                fi

                # --> Bonjourr Startpage for Safari
                if [ "$installBonjourrStartpageForSafari" = true ]; then
                    masinstallAppBonjourrStartpage
                    storeprogress "installBonjourrStartpageForSafari" "$rerunconfig"
                fi

                # --> Strongbox
                if [ "$installStrongbox" = true ]; then
                    masinstallAppStrongbox
                    storeprogress "installStrongbox" "$rerunconfig"
                fi

                # --> Pixelmator Pro
                if [ "$installPixelmator" = true ]; then
                    masinstallAppPixelmator
                    storeprogress "installPixelmator" "$rerunconfig"
                fi

                storeprogress "installAppStoreApps" "$rerunconfig"

            # Mac App Store CLI was NOT installed
            else
                showinfo "Not authenticated in Mac App Store!\n--> Mac App Store CLI (mas) not installed" "error"

                # --> 1Password for Safari
                if [ "$install1Password" = true ]; then
                    showinfo "Install App manually from App Store: '1Password for Safari'" "notice"
                fi

                # --> AdGuard for Safari
                if [ "$installAdGuardSafari" = true ]; then
                    showinfo "Install App manually from App Store: 'AdGuard for Safari'" "notice"
                fi

                # --> Strongbox
                if [ "$installStrongbox" = true ]; then
                    showinfo "Install App manually from App Store: 'Strongbox Password Manager'" "notice"
                fi

                # --> Pixelmator Pro
                if [ "$installPixelmator" = true ]; then
                    showinfo "Install App manually from App Store: 'Pixelmator Pro'" "notice"
                fi
            fi
        fi
        # END -- Mac App Store CLI --
    else
        # Homebrew was NOT installed
        showinfo "Homebrew could not be installed" "error"
    fi
fi
# END -- Homebrew --

# -- Development Tools --
# --> Git Command Line Tools
# (Skipped if already installed through Xcode Command Line Tools)
if [ "$installGit" = true ] && checkIfHomebrewInstalled; then
    if ! checkIfXcodeInstalled; then
        showinfo "Installing Git:" "note"
        brewinstallAppGit
        showinfo "" "confirm"
        if checkIfHomebrewInstalled; then
            showinfo "Installing git-credentials-manager (to work with Fork):" "note"
            brewinstallAppGitCredentialsManager
            showinfo "" "confirm"
        fi
    else
        showinfo "Git may already be installed through Xcode CLT:" "note"
        git -v
    fi
    storeprogress "installGit" "$rerunconfig"
fi

# --> Web Dev --
if [ "$installWebdevTools" = true ]; then
    showinfo "Installing Web Development Tools:" "notice"

    # -- Composer --
    if [ "$installComposer" = true ] && checkIfHomebrewInstalled; then
        # -- PHP --
        # (pre-requisite for Composer)
        showinfo "Installing PHP:" "note"
        brewinstallAppPHP
        showinfo "" "confirm"

        showinfo "Installing Composer:" "note"
        brewinstallAppComposer
        showinfo "" "confirm"

        storeprogress "installComposer" "$rerunconfig"
    fi

    # -- Gas Mask.app --
    if [ "$installGasMask" = true ]; then
        showinfo "Installing Gas Mask Hostfiles-Manager:" "note"
        installAppGasMask
        showinfo "" "confirm"
        storeprogress "installGasMask" "$rerunconfig"
    fi

    # -- Hedit.app --
    if [ "$installHedit" = true ]; then
        showinfo "Installing Hedit Hostfiles-Manager:" "note"
        installAppHedit
        showinfo "" "confirm"
        storeprogress "installHedit" "$rerunconfig"
    fi

    # -- Sequel Ace.app --
    if [ "$installSequelAce" = true ] && checkIfHomebrewInstalled; then
        showinfo "Installing Sequel Ace Database-Manager:" "note"
        brewinstallAppSequelAce
        showinfo "" "confirm"
        storeprogress "installSequelAce" "$rerunconfig"
    fi

    if [ "$installDocker" = true ] || [ "$useOrbStackOverDocker" = true ]; then
        # -- OrbStack (preferred over Docker) --
        if [ "$useOrbStackOverDocker" = true ]; then
            showinfo "Installing OrbStack (all-in-one Docker for Mac):" "note"
            if checkIfHomebrewInstalled; then
                brewinstallAppOrbStack
            else
                installAppOrbStack
            fi
            showinfo "" "confirm"
            storeprogress "useOrbStackOverDocker" "$rerunconfig"

            # -- SonarQube (for Docker) --
            if [ "$installSonarQube" = true ] && checkIfHomebrewInstalled; then
                showinfo "Installing SonarQube for Docker:" "note"
                brewinstallAppSonarQube
                showinfo "" "confirm"
                storeprogress "installSonarQube" "$rerunconfig"
            fi
        # -- Docker for Mac --
        elif [ "$installDocker" = true ] && checkIfHomebrewInstalled; then
            showinfo "Installing Docker for Mac:" "note"
            brewinstallAppDocker
            showinfo "" "confirm"
            storeprogress "installDocker" "$rerunconfig"

            # -- SonarQube (for Docker) --
            if [ "$installSonarQube" = true ]; then
                showinfo "Installing SonarQube for Docker:" "note"
                brewinstallAppSonarQube
                showinfo "" "confirm"
                storeprogress "installSonarQube" "$rerunconfig"
            fi
        fi
    elif [ "$installMAMP" = true ]; then
        # -- MAMP Suite --
        showinfo "Installing MAMP (Mac Apache MySQL PHP):" "note"
        installAppMAMP
        storeprogress "installMAMP" "$rerunconfig"
    fi

    # -- Node.js, npm, and Grunt --
    if [ "$installNodejs" = true ] && checkIfHomebrewInstalled; then
        showinfo "Installing Node.js, npm, and Grunt:" "note"
        brewinstallAppNodejs
        showinfo "" "confirm"
        storeprogress "installNodejs" "$rerunconfig"
    fi
fi
# END -- Web Dev --

# -- Disabling Quarantine flags for new Applications --
if checkIfFileExists "$HOME/Applications"; then
   showinfo "Trying to clear new Apps from macOS Quarantine:" "note"
   disableAppQuarantine "$HOME/Applications"
   showinfo "" "confirm"
fi

# -- ENABLE macOS Gatekeepr (if disabled) --
if ! macosGatekeeper; then
    showinfo "ENABLING Gatekeeper to disallow unsiged Applications:" "note"
    macosGatekeeper "on"
    showinfo "" "confirm"
fi



# ------------------------------
#       APP CONFIGURATIONS
# ------------------------------
showinfo "APPLY APP CONFIGURATIONS" "shout"
# -- Dock customizations --
if [ "$beautifyDock" = true ] && [ ! "$minimalDock" ]; then
    showinfo "Beautifying the Dock:" "note"
    source "$SCRIPT_DIR/Usersettings/Dock.sh" > /dev/null
    # --> Add divider to Dock
    addSpacerToDock
    # --> Add installed App Icons to Dock
    if [ "$installBraveBrowser" = true ]; then
        addAppToDock "Brave"
    fi
    if [ "$installBoop" = true ]; then
        addAppToDock "Boop"
    fi
    if [ "$installDiscord" = true ]; then
        addAppToDock "Discord"
    fi
    if [ "$installFirefoxBrowser" = true ]; then
        addAppToDock "Firefox"
    fi
    if [ "$installFigma" = true ]; then
        addAppToDock "Figma"
    fi
    if [ "$installFork" = true ]; then
        addAppToDock "Fork"
    fi
    if [ "$installGoogleChromeBrowser" = true ]; then
        addAppToDock "Google Chrome"
    fi
    if [ "$installGrandPerspective" = true ]; then
        addAppToDock "GrandPerspective"
    fi
    if [ "$installHalloyIRC" = true ]; then
        addAppToDock "Halloy"
    fi
    if [ "$installNotion" = true ]; then
        addAppToDock "Notion"
    fi
    if [ "$installNova" = true ]; then
        addAppToDock "Nova"
    fi
    if [ "$installPixelmator" = true ]; then
        addAppToDock "Pixelmator Pro"
    fi
    if [ "$installSpotify" = true ]; then
        addAppToDock "Spotify"
    fi
    if [ "$installStrongbox" = true ]; then
        addAppToDock "Strongbox"
    fi
    if [ "$installSteam" = true ]; then
        addAppToDock "Steam"
    fi
    if [ "$installTransmission" = true ]; then
        addAppToDock "Transmission"
    fi
    if [ "$installTelegram" = true ]; then
        addAppToDock "Telegram"
    fi
    if [ "$installTresorit" = true ]; then
        addAppToDock "Tresorit"
    fi
    if [ "$installVisualStudioCode" = true ]; then
        addAppToDock "Visual Studio Code"
    fi
    if [ "$installVLC" = true ]; then
        addAppToDock "VLC"
    fi
    if [ "$installWarp" = true ]; then
        addAppToDock "Warp"
    fi
    if [ "$installXnapper" = true ]; then
        addAppToDock "Xnapper"
    fi
    if [ "$installWebdevTools" = true ]; then
        addSpacerToDock
        if [ "$installGasMask" = true ]; then
            addAppToDock "Gas Mask"
        fi
        if [ "$installHedit" = true ]; then
            addAppToDock "Hedit"
        fi
        if [ "$installSequelAce" = true ]; then
            addAppToDock "Sequel Ace"
        fi
    fi
    showinfo "" "confirm"
    storeprogress "beautifyDock" "$rerunconfig"
fi

# -- Set-up Git and SSH --
if ( [[ "$installWebdevTools" = true || "$installGit" = true ]] || checkIfXcodeInstalled ) \
   && checkIfNotEmpty "$gitUseremail"; then
    # --> Git configs
    showinfo "Configuring Git:" "note"
    setGitconfigs
    showinfo "" "confirm"

    # --> SSH
    showinfo "Configuring an SSH Key to use with Git:" "note"
    generateSSHKey
    showinfo "" "confirm"
fi

# -- Terminal Configs --
if [ "$enableTerminalUtf8" = true ]; then
    showinfo "Enabling UTF-8 as default for the Terminal:" "note"
    enableTerminalUtf8
    showinfo "" "confirm"
    storeprogress "enableTerminalUtf8" "$rerunconfig"
fi
if [ "$useCustomTerminalTheme" = true ] && checkIfNotEmpty "$useCustomTerminalThemeURL"; then
    showinfo "Installing custom Terminal Theme file:" "note"
    downloadTerminalCustomTheme
    showinfo "" "confirm"
    storeprogress "useCustomTerminalTheme" "$rerunconfig"
fi
if [ "$useCustomTerminalConfigurations" = true ] && checkIfNotEmpty "$useCustomTerminalConfigurationsURL"; then
    showinfo "Adding custom Terminal commands to ~/.zshrc:" "note"
    downloadTerminalzshrcContents
    showinfo "" "confirm"
    storeprogress "useCustomTerminalConfigurations" "$rerunconfig"
fi



# ------------------------------
#        CUSTOM COMMANDS
#
#  Executes custom commands from
#  mycommands.sh
# ------------------------------
showinfo "APPLY CUSTOM COMMANDS" "shout"
if checkIfFileExists "$SCRIPT_DIR/mycommands.sh" && [ -s "$SCRIPT_DIR/mycommands.sh" ]; then
    showinfo "Executing custom commands:" "note"
    bash "$SCRIPT_DIR/mycommands.sh"
    showinfo "(mycommands.sh)" "confirm"
else
    showinfo "(not required)" "note"
fi



# ------------------------------
#            BYE BYE
# ------------------------------
if ! ask "Do you want to keep the setup progress file ($rerunconfig)?"; then
    discard_rerunconfig
fi
showinfo "" "shout"
showinfo "🚀 ALL DONE : Setup completed. Enjoy using your setup!" "shout"
exit 0
