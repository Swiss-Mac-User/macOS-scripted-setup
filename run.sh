#!/usr/bin/env zsh

# ------------------------------
#          INITIALIZE
# ------------------------------
# Load Helper functions persistently
source helpers.sh > /dev/null

# Load the right configuration file
showinfo "Loading setup configuration" "shout"
if checkIfFileExists "config.sh"; then
    # Load CUSTOM configs
    source config.sh > /dev/null
    showinfo "custom configs (config.sh)" "confirm"
else
    # Fallback: Load DEFAULT configs
    source config.default.sh > /dev/null
    showinfo "default configs (config.default.sh)" "confirm"
fi



# ------------------------------
#   SETUP MACOS SYSTEM SERVICES
# ------------------------------
showinfo "SETUP MACOS SYSTEM SERVICES" "shout"
for service in ./Systemservices/*.sh; do
    [ -r "$service" ] && source $service > /dev/null
done
unset service
# -- FileVault2 --
if [ "$useFileVault" = true ]; then
    showinfo "Enabling FileVault:" "note"
    enableFileVault
    showinfo "" "confirm"
fi
# -- Built-in Firewall --
if [ "$enableFirewall" = true ]; then
    showinfo "Enabling Firewall Stealthmode:" "note"
    activateFirewallStealthmode
    showinfo "" "confirm"
    showinfo "Enabling Firewall:" "note"
    enableFirewall
    showinfo "" "confirm"
fi
# -- Time Machine --
if [ "$speedupTimemachine" = true ]; then
    showinfo "Disabling Time Machine prompts for new connected drives:" "note"
    muteTimeMachine
    showinfo "" "confirm"
    showinfo "Throttling Time Machine process priority:" "note"
    speedupTimeMachine
    showinfo "" "confirm"
fi
# -- AirDrop --
if [ "$enableWiredAirDrop" = true ]; then
    showinfo "Enabling AirDrop through Ethernet:" "note"
    enableAirDropOnEthernet
    showinfo "" "confirm"
fi
# -- Login and Password --
if [ "$disableShutdownRestartInLogin" = true ]; then
    showinfo "Disabling 'Shutdown' button on Login window:" "note"
    disableShutdownOnLogin
    showinfo "" "confirm"
    showinfo "Disabling 'Restart' button on Login window:" "note"
    disableRestartOnLogin
    showinfo "" "confirm"
fi
if [ "$enableScreensaverPassword" = true ]; then
    showinfo "Enabling password prompt when interrupting Screensaver:" "note"
    enableUserpasswordOnScreensaver
    showinfo "" "confirm"
fi
if [ "$playMacStartupSound" = true ]; then
    showinfo "Enabling the iconic Startup Chime on your Mac:" "note"
    enableStartupChime
    showinfo "" "confirm"
fi



# ------------------------------
#      APPLY USER SETTINGS
# ------------------------------
showinfo "APPLY USER SETTINGS" "shout"
for setting in ./Usersettings/*.sh; do
    [ -r "$setting" ] && source $setting > /dev/null
done
unset setting

# -- Application Performance --
if [ "$betterApplicationPerformance" = true ]; then
    showinfo "Disabling App Nap (application power saving):" "note"
    disableAppNap
    setActivityMonitorProcesslist
    showinfo "" "confirm"
fi

# -- macOS Layout --
if [ "$dateTimeInMenubar" = true ]; then
    showinfo "Setting analog Menu Clock:" "note"
    setReadableMenuclock
    showinfo "" "confirm"
fi
if [ "$showScrollbars" = true ]; then
    showinfo "Setting always visible Scrollbars:" "note"
    alwaysShowScrollbars
    showinfo "" "confirm"
fi
if [ "$disableNaturalScrolling" = true ]; then
    showinfo "Disabling Natural Scrolling:" "note"
    disableNaturalScrolling
    showinfo "" "confirm"
fi
if [ "$disableTransparency" = true ]; then
    showinfo "Disabling transparencies and tinting (windows, menubar):" "note"
    disableTransparencyAndTinting
    showinfo "" "confirm"
fi
if [ "$useRealNamesForContacts" = true ]; then
    showinfo "Enable using real names for Contacts (instead of Nicknames):" "note"
    disableContactstNicknames
    showinfo "" "confirm"
fi

# -- Mission Control --
if [ "$useMissionControl" = true ]; then
    showinfo "Configuring Mission Control:" "note"
    setMissionControlHotCorners
    groupMissionControlByApplication
    switchMissionControlSpacesByApplication
    useMissionControlSpacePerDisplay
    showinfo "" "confirm"
fi

# -- Control Centre --
if [ "$enableFastUserswitching" = true ]; then
    showinfo "Enabling Fast User Switching:" "note"
    enableFastUserSwitching
    showFastUserSwitching
    showinfo "" "confirm"
fi
if [ "$showBatteryPercentage" = true ] && checkIfMacIsPortable; then
    showinfo "Show Battery %-Percentage:" "note"
    showBatteryPercentage
    showinfo "" "confirm"
fi

# -- macOS Text / Keyboard Input --
if [ "$disableAnnoyingTextcorrections" = true ]; then
    showinfo "Disabling annoying automatic Text corrections:" "note"
    disableTextAutocorrect
    disableTextCapitalisation
    disableTextPeriodSubstitution
    showinfo "" "confirm"
fi
if [ "$enableTrackpadClicks" = true ] && checkIfMacIsPortable; then
    showinfo "Enable Tap to Click on the Trackpad:" "note"
    enableTrackpadClicking
    showinfo "" "confirm"
fi
if [ "$fasterMouseCursor" = true ]; then
    showinfo "Speedup Cursor on Trackpads and Mouses:" "note"
    increaseMouseSpeed
    showinfo "" "confirm"
fi

# -- Dock --
if [ "$speedupDock" = true ]; then
    showinfo "Enabling auto-hiding the Dock:" "note"
    autohideDock
    showinfo "" "confirm"
    showinfo "Making the Dock hide/show much snappier:" "note"
    speedupDock
    showinfo "" "confirm"
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
fi
if [ "$minimalDock" = true ]; then
    showinfo "Showing only active Apps in the Dock:" "note"
    showOnlyRunningAppsInDock
    showinfo "" "confirm"
fi
restartDock

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
    showAllFileExtensions
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
    updateApplicationsFolderListColumns
    showinfo "" "confirm"

    # --> Screenshots
    showinfo "Improving Screenshots:" "note"
    saveScreenshotsAs
    if [ "$useScreenshotsNumericFilename" = true ]; then
        useNumericScreenshots
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
fi
# -- Safari --
if [ "$secureSafariBrowser" = true ]; then
    showinfo "More Privacy and Security for Safari:" "notice"
    # --> Private
    showinfo "Enabling Private Search and No Tracking:" "note"
    privateSearchQueriesInSafari
    noContentTrackingInSafari
    showinfo "" "confirm"
    # --> Security
    showinfo "Enabling all Security features in Safari:" "note"
    showFullUrlInSafari
    preventUnpackingDownloadedFilesInSafari
    preventVisitingBadWebsitesInSafari
    preventOutdatedExtensionsInSafari
    preventAutofillingYourDataInSafari
    enableDeveloperToolsInSafari
    showinfo "" "confirm"
fi

# -- Userhome Files + Folders --
for filesetting in ./FilesFolders/*.sh; do
    [ -r "$filesetting" ] && source $filesetting > /dev/null
done
unset filesetting
showinfo "CREATING ADDITIONAL FOLDERS AND FILES" "shout"
# --> Library folder
if [ "$showLibraryFolder" = true ]; then
    showinfo "Making the ~/Library folder in userhome visible:" "note"
    showUserhomeLibraryFolder
    showinfo "" "confirm"
fi
# --> Applications
if [ "$addUserApplicationsFolder" = true ]; then
    showinfo "Adding a ~/Applications folder to userhome:" "note"
    createUserFolderApplications
    showinfo "" "confirm"
fi
# --> Sites
if [ "$addUserWebsitesFolder" = true ]; then
    showinfo "Adding a ~/Sites folder to userhome:" "note"
    createUserFolderSites
    showinfo "" "confirm"
fi
# --> Games
if [ "$addUserGamesFolder" = true ]; then
    showinfo "Adding a ~/Games folder to userhome:" "note"
    createUserFolderGames
    showinfo "" "confirm"
fi
# --> Desktop Pictures
if [ "$downloadWallpapers" = true ]; then
    showinfo "Adding Desktop Pictures folder to userhome ~/Pictures/:" "note"
    createUserFolderDesktopPictures
    showinfo "" "confirm"

    if [ "$dynamicWallpaperExodus" = true ]; then
        showinfo "...downloading «Exodus» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        downloadWallpaperExodus
    fi
    if [ "$dynamicWallpaperFuji" = true ]; then
        showinfo "...downloading «Fuji» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        downloadWallpaperFuji
    fi
    if [ "$dynamicWallpaperISS" = true ]; then
        showinfo "...downloading «ISS» wallpaper to ~/Pictures/Desktop Pictures/" "note"
        downloadWallpaperISS
    fi
    showinfo "" "confirm"
fi



# ------------------------------
#   APPLICATION INSTALLATIONS
#
# Note:
# open -g Do not bring the application to the foreground.
#      -j Launches the app hidden.
# ------------------------------
showinfo "APPLICATION INSTALLATIONS" "shout"
for app in ./Applications/*.sh; do
    [ -r "$app" ] && source $app > /dev/null
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
fi
if [ "$removeiMovie" = true ]; then
    showinfo "Removing iMovie App:" "note"
    removeAppiMovie
    showinfo "(removed if present)" "confirm"
fi
# -- Rosetta for macOS --
if [ "$installRosetta" = true ]; then
    showinfo "Installing Rosetta:" "note"
    installAppRosetta
    showinfo "" "confirm"
fi
# -- Keka.app --
if [ "$installKeka" = true ]; then
    showinfo "Installing Keka:" "note"
    installAppKeka
    showinfo "" "confirm"
fi
# -- 1Password.app --
if [ "$install1Password" = true ]; then
    showinfo "Installing 1Password:" "note"
    installApp1Password
    showinfo "" "confirm"
fi
# -- Transmission.app --
if [ "$installTransmission" = true ]; then
    showinfo "Installing Transmission:" "note"
    installAppTransmission
    showinfo "" "confirm"
fi
# -- Tresorit.app --
if [ "$installTresorit" = true ]; then
    showinfo "Installing Tresorit:" "note"
    installAppTresorit
    showinfo "" "confirm"
fi
# -- Telegram.app --
if [ "$installTelegram" = true ]; then
    showinfo "Installing Telegram:" "note"
    installAppTelegram
    showinfo "" "confirm"
fi
# -- Xnapper.app --
if [ "$installXnapper" = true ]; then
    showinfo "Installing Xnapper:" "note"
    installAppXnapper
    showinfo "" "confirm"
fi
# -- Spotify.app --
if [ "$installSpotify" = true ]; then
    showinfo "Installing Spotify:" "note"
    installAppSpotify
    showinfo "" "confirm"
fi
# -- Discord.app --
if [ "$installDiscord" = true ]; then
    showinfo "Installing Discord:" "note"
    installAppDiscord
    showinfo "" "confirm"
fi
# -- Google Chrome.app --
if [ "$installGoogleChrome" = true ]; then
    showinfo "Installing Google Chrome Browser:" "note"
    installAppGoogleChrome
    showinfo "" "confirm"
fi
# -- Mozilla Firefox.app --
if [ "$installFirefox" = true ]; then
    showinfo "Installing Firefox Browser:" "note"
    installAppFirefox
    showinfo "" "confirm"
fi
# -- Beyond Compare --
if [ "$installBeyondCompare" = true ]; then
    showinfo "Installing Beyond Compare:" "note"
    installAppBeyondCompare
    showinfo "" "confirm"
fi
# -- Warp --
if [ "$installWarp" = true ]; then
    showinfo "Installing Warp Terminal:" "note"
    installAppWarp
    showinfo "" "confirm"
fi
# -- Visual Studio Code --
if [ "$installVisualStudioCode" = true ]; then
    showinfo "Installing Visual Studio Code:" "note"
    installAppVSCode
    showinfo "" "confirm"
fi
# -- Microsoft Office / Office 365 for Mac --
if [ "$installMicrosoftOffice" = true ]; then
    showinfo "Installing Microsoft Office for Mac:" "note"
    installAppMicrosoftOffice
    showinfo "" "confirm"
fi
# -- VLC Media Player --
if [ "$installVLC" = true ]; then
    showinfo "Installing VLC Media Player:" "note"
    installAppVLC
    showinfo "" "confirm"
fi
# -- Steam --
if [ "$installSteam" = true ]; then
    showinfo "Installing Steam:" "note"
    installAppSteam
    showinfo "" "confirm"
fi
# -- Whisky --
if [ "$installWhisky" = true ]; then
    showinfo "Installing Whisky:" "note"
    installAppWhisky
    showinfo "" "confirm"
fi
# -- Xcode Command Line Tools --
if [ "$installXcodeTools" = true ] || [ "$installHomebrew" = true ]; then
    # !! NOTE: Pre-requisite for Homebrew !!
    showinfo "Installing Xcode Command Line Tools (xcode):" "note"
    installAppXcodeCLT
    if checkIfXcodeInstalled; then
        showinfo "" "confirm"
    else
        showinfo "Xcode Command Line Tools were not installed" "error"
    fi
fi
# -- Homebrew --
if [ "$installHomebrew" = true ]; then
    showinfo "Installing Homebrew (brew):" "note"
    installAppHomebrew

    # Extend macOS Functionality with helpful Tools
    if checkIfHomebrewInstalled; then
        showinfo "" "confirm"

        # -- Install Apps via Homebrew --
        showinfo "Installing GnuPG, OpenSSH, and wget:" "note"
        brewinstallAppGnuPG
        brewinstallAppOpenSSH
        brewinstallAppWget
        showinfo "" "confirm"

        # --> Syntax Highlight (Quick Look Extension)
        if [ "$installSyntaxHighlightQuickLook" = true ]; then
            showinfo "Installing Syntax Highlight Quick-Look plugin:" "note"
            brewinstallAppSyntaxHighlight
            showinfo "" "confirm"
        fi

        # --> Fig.io
        if [ "$installFig" = true ]; then
            showinfo "Installing Fig:" "note"
            brewinstallAppFig
            showinfo "" "confirm"
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

                # --> AdGuard for Safari
                if [ "$installAdGuardSafari" = true ]; then
                    masinstallAppAdGuardSafariExtension
                fi

                # --> 1Password for Safari
                if [ "$install1Password" = true ]; then
                    masinstallApp1PasswordSafariExtension
                fi

                # --> Strongbox
                if [ "$installStrongbox" = true ]; then
                    masinstallAppStrongbox
                fi

                # --> Pixelmator Pro
                if [ "$installPixelmator" = true ]; then
                    masinstallAppPixelmator
                fi

            # Mac App Store CLI was NOT installed
            else
                showinfo "Not authenticated in Mac App Store!\n--> Mac App Store CLI (mas) not installed" "error"

                # --> AdGuard for Safari
                if [ "$installAdGuardSafari" = true ]; then
                    showinfo "Install App manually from App Store: 'AdGuard for Safari'" "notice"
                fi

                # --> 1Password for Safari
                if [ "$install1Password" = true ]; then
                    showinfo "Install App manually from App Store: '1Password for Safari'" "notice"
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

# -- Web Dev (install) --
if [ "$installWebdevTools" = true ]; then
    showinfo "Installing Web Development Tools:" "notice"

    # -- Git Command Line Tools --
    # (Skipped if already installed through Xcode Command Line Tools)
    if [ "$installGit" = true ] && ! checkIfXcodeInstalled; then
        showinfo "Installing Git:" "note"
        brewinstallAppGit
        showinfo "" "confirm"
    else
        showinfo "Git is already installed" "confirm"
    fi

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
    fi

    # -- Fork.app --
    if [ "$installFork" = true ]; then
        showinfo "Installing Fork App:" "note"
        installAppFork
        showinfo "" "confirm"
    fi

    # -- Nova.app --
    if [ "$installNova" = true ]; then
        showinfo "Installing Nova App:" "note"
        installAppNova
        showinfo "" "confirm"
    fi

    # -- Gas Mask.app --
    if [ "$installGasMask" = true ]; then
        showinfo "Installing Gas Mask Hostfiles-Manager:" "note"
        installAppGasMask
        showinfo "" "confirm"
    fi

    # -- Sequel Ace.app --
    if [ "$installSequelAce" = true ] && checkIfHomebrewInstalled; then
        showinfo "Installing Sequel Ace Database-Manager:" "note"
        brewinstallAppSequelAce
        showinfo "" "confirm"
    fi

    # -- Boop.app --
    if [ "$installBoop" = true ] && checkIfHomebrewInstalled &&
       checkIfAppStoreAuthenticated; then
        showinfo "Installing Boop App:" "note"
        masinstallAppBoop
        showinfo "" "confirm"
    fi

    if [ "$installMAMP" = false ] || [ ! "$installMAMP" ]; then
        # -- Docker --
        if [ "$installDocker" = true ] && checkIfHomebrewInstalled; then
            showinfo "Installing Docker for Mac:" "note"
            brewinstallAppDocker
            showinfo "" "confirm"

            # -- SonarQube (for Docker) --
            if [ "$installSonarQube" = true ]; then
                showinfo "Installing SonarQube for Docker:" "note"
                brewinstallAppSonarQube
                showinfo "" "confirm"
            fi
        fi
    elif [ "$installMAMP" = true ]; then
        # -- MAMP Suite --
        installAppMAMP
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
if [ "$beautifyDock" = true ] && [ "$minimalDock" != true ]; then
    showinfo "Beautifying the Dock:" "note"
    # --> Add installed App Icons to Dock
    addSpacerToDock
    if [ "$installTransmission" = true ]; then
        addAppToDock "Transmission"
    fi
    if [ "$installTelegram" = true ]; then
        addAppToDock "Telegram"
    fi
    if [ "$installXnapper" = true ]; then
        addAppToDock "Xnapper"
    fi
    if [ "$installDiscord" = true ]; then
        addAppToDock "Discord"
    fi
    if [ "$installFirefox" = true ]; then
        addAppToDock "Firefox"
    fi
    if [ "$installGoogleChrome" = true ]; then
        addAppToDock "Google Chrome"
    fi
    if [ "$installStrongbox" = true ]; then
        addAppToDock "Strongbox"
    fi
    if [ "$installPixelmator" = true ]; then
        addAppToDock "Pixelmator Pro"
    fi
    if [ "$installWebdevTools" = true ]; then
        addSpacerToDock
        addAppToDock "Fork"
        addAppToDock "Nova"
        addAppToDock "Sequel Ace"
        addAppToDock "Boop"
    fi
    showinfo "" "confirm"
fi

# -- Set-up Git and SSH --
if [[ "$installWebdevTools" = true && "$installGit" = true ]] ||
   checkIfXcodeInstalled; then
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
fi
if [ "$useCustomTerminalTheme" = true ]; then
    showinfo "Installing custom Terminal Theme file:" "note"
    downloadTerminalCustomTheme
    showinfo "" "confirm"
fi
if [ "$useCustomTerminalConfigurations" = true ]; then
    showinfo "Adding custom Terminal commands to ~/.zshrc:" "note"
    downloadTerminalzshrcContents
    showinfo "" "confirm"
fi



# ------------------------------
#        CUSTOM COMMANDS
#
#  Executes custom commands from
#  mycommands.sh
# ------------------------------
showinfo "APPLY CUSTOM COMMANDS" "shout"
if checkIfFileExists "mycommands.sh" && [ -s mycommands.sh ]; then
    showinfo "Executing custom commands:" "note"
    bash mycommands.sh
    showinfo "(mycommands.sh)" "confirm"
else
    showinfo "(not required)" "note"
fi
