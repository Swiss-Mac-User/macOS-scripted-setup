#!/usr/bin/env zsh

# -----------------------------------------------
#                  INSTRUCTIONS
#                      ---
#  Copy this file as a "config.sh" and set your
#  preferences for the options using "true" or "false"
#  (if there is no config.sh, the default file is used)
#
#
#               TABLE OF CONTENTS
#                      ---
#  1. macOS System Services
#   |- 1.1 Security
#   |- 1.2 Time Machine
#   |- 1.3 AirDrop
#   |_ 1.4 System Updates
#   |_ 1.5 Performance
#   |_ 1.6 System boot
#
#  2. Applications
#   |- 2.1 Remove Applications
#   |- 2.2 Required Apps
#   |- 2.3 Finder Extensions
#   |- 2.4 Application installations
#   |- 2.5 Development Tools
#   |   |_ 2.5.1 Web Development Suite
#   |_ 2.6 Mac Gaming
#
#  3. User Settings
#   |- 3.1 Layout / User Interface
#   |   |- 3.1.1 Menu Bar
#   |   |- 3.1.2 Window handling
#   |   |- 3.1.3 Text handling
#   |   |- 3.1.4 Keyboard & Mouse
#   |   |- 3.1.5 Apple Apps
#   |- 3.2 Finder
#   |   |- 3.2.1 Files
#   |   |_ 3.2.2 Screenshots
#   |- 3.3 Dock
#   |- 3.4 User Home
#   |   |_ 3.4.1 Wallpapers (Desktop Pictures)
#   |- 3.5 Terminal
#   |- 3.6 Application Hardening
#   |- 3.7 Night Shift
#   |_ 3.8 Display
#

# ------------------------------
#     1. macOS System Services
# ------------------------------
# -- 1.1 Security --
useFileVault=true
enableFirewall=true
disableShutdownRestartInLogin=true
enableScreensaverPassword=true

# -- 1.2 Time Machine --
speedupTimemachine=true

# -- 1.3 AirDrop --
enableWiredAirDrop=true

# -- 1.4 Check and install System updates --
installSystemUpdates=true

# -- 1.5 Performance settings --
betterApplicationPerformance=true

# -- 1.6 System boot up --
playMacStartupSound=true


# ------------------------------
#     2. Applications
# ------------------------------
# -- 2.1 Remove pre-installed Apps --
removeGarageband=false
removeiMovie=false

# -- 2.2 Required Applications --
# (others have dependencies for these)
installXcodeTools=false
installHomebrew=true
# (!) Requires Homebrew: installHomebrew=TRUE
installAppStoreApps=true
installRosetta=false

# -- 2.3 Install Finder Extensions --
installKeka=true
installQuickLookPlugins=true

# -- 2.4 Install Applications --
install1Password=false
installAdGuardSafari=true
installBonjourrStartpageForSafari=true
# (!) installAlDente: Only supported on MacBooks (MBA, MBP)
installAlDente=false
installBeyondCompare=false
installBoop=false
installDiscord=false
installEqMac=false
installFigma=false
installFork=false
installGrandPerspective=false
installHalloyIRC=false
installLinearMouse=false
installMacsFanControl=false
installMicrosoftOffice=false
installNotion=false
installNova=false
installOverSight=true
installPixelmator=false
installSentinel=true
installSpotify=false
installStrongbox=false
installTelegram=false
installTransmission=false
installTresorit=false
installVisualStudioCode=false
installVLC=false
installWarp=false
installXnapper=false
# -- 2.4.1 Web Browsers --
installBraveBrowser=false
installFirefoxBrowser=false
installGoogleChromeBrowser=false

# -- 2.5 Development Tools --
# (i) gitUsername = visible Display Name; gitUseremail = visible Email address with git
installGit=false
gitUsername=''
gitUseremail=''
# -- 2.5.1 Web Development Suite --
# (!) When FALSE then all below steps are SKIPPED
installWebdevTools=false
# (i) installComposer will also install local PHP
installComposer=false
# (!) Only installed when: MAMP=FALSE
installDocker=false
# (i) Use OrbStack instead of Docker
useOrbStackOverDocker=false
installGasMask=false
installHedit=false
installMAMP=false
installNodejs=false
installSequelAce=false
# (!) Only installed when: Docker=TRUE
installSonarQube=false

# -- 2.6 Mac Gaming Apps and Games --
installHeroicGamesLauncher=false
installSteam=false

# ------------------------------
#     3. User and App Settings
# ------------------------------
# -- 3.1 macOS Layout / User Interface --
# ---- 3.1.1 Menu Bar ----
dateTimeInMenubar=true
enableFastUserswitching=true
useMissionControl=true
disableTransparency=true
# (!) showBatteryPercentage: only applied on MacBooks (MBA, MBP)
showBatteryPercentage=true
# ---- 3.1.2 Window handling ----
enableFullDraggableWindows=false
showScrollbars=true
# ---- 3.1.3 Text handling ----
disableAnnoyingTextcorrections=true
# ---- 3.1.4 Keyboard & Mouse ----
disableNaturalScrolling=true
# (!) enableTrackpadClicks: only applied on MacBooks (MBA, MBP)
enableTrackpadClicks=true
fasterMouseCursor=true
# (i) fnKeyFunction Modes: off=Do nothing, emoji=Emojis & Symbols, language=Input sources, dictation=Start Dictation
fnKeyFunction='emoji'
enableTabFocusChange=false
disableDoubleSpacePeriod=true
# ---- 3.1.5 Apple Apps ----
useRealNamesForContacts=true
showMusicNextSongPlaying=false
showSubjectInMessagesApp=false

# -- 3.2 macOS Finder customizations --
# (!) If false, below settings will have NO effect
customizeFinder=true
# ---- 3.2.1 Files in Finder ----
showFileExtensions=false
# ---- 3.2.2 Screenshots ----
# (i) Supported formats: bmp, gif, heic, jpg, jp2, tif, pict, pdf, png, tga, tiff
useScreenshotsFormat='png'
useScreenshotsNumericFilename=false

# -- 3.3 macOS Dock optimizations --
speedupDock=true
beautifyDock=true
minimalDock=false

# -- 3.4 User Home folder --
showLibraryFolder=true
addUserApplicationsFolder=true
addUserWebsitesFolder=true
addUserGamesFolder=true
# ---- 3.4.1 Wallpapers (Desktop Pictures) ----
# (i) Must be enabled to download any of the Wallpapers below
downloadWallpapers=true
dynamicWallpaperDesert=false
dynamicWallpaperExodus=false
dynamicWallpaperFuji=false
dynamicWallpaperFluted=false
dynamicWallpaperHivemind=false

# -- 3.5 Terminal app settings --
enableTerminalUtf8=true
# (i) Requires the URL from next line to download .terminal Theme file
useCustomTerminalTheme=false
useCustomTerminalThemeURL='https://gist.githubusercontent.com/oliveratgithub/c9dde424966a7b9b5b7e9d1c28bf8f2e/raw/'
# (i) If true, a URL is required to download and apply .zhsrc commands
useCustomTerminalConfigurations=false
useCustomTerminalConfigurationsURL=''

# -- 3.6 Application Hardening --
secureSafariBrowser=true
# (i) Auto-remove items from Trash after 30 days
removeTrashbinItemsPeriodically=true

# -- 3.7 Night Shift --
enableNightShift=true

# -- 3.8 Display --
enableAllResolutions=false
