-- ==================================================
--   macOS Scripted Setup - Config Settings Wizard
-- ==================================================
-- Bundle Info
-- --------------------------------------------------
-- Name: 			Config Wizard macOS Scripted Setup
-- Identifier: 		com.apple.ScriptEditor.id.macOSScriptedSetupConfigHelper
-- Short Version: 	1.0.1
-- Bundle Version: 	2
-- Copyright: 		© 2026 github.com/Swiss-Mac-User/macOS-scripted-setup

-- --------------------------------------------------
-- Settings
-- --------------------------------------------------
-- Contents
property configContent : ""
property configStepsCompleted : 0
set progress total steps to 28
set progress completed steps to 0
set progress description to "Settings walk-through..."

-- Paths (POSIX throughout; use POSIX file for file ops)
set scriptFolder to POSIX path of ((path to me as text) & "::")
set configPath to scriptFolder & "config.sh"
set configRerunPath to scriptFolder & "config.rerun.sh"

-- Current date and time
set now to current date
set y to year of now
set m to (month of now) as integer
set d to day of now
set h to hours of now
set min to minutes of now
set s to seconds of now
set dateStr to (y as text) & text -2 thru -1 of ("0" & m) & text -2 thru -1 of ("0" & d)
set timeStr to text -2 thru -1 of ("0" & h) & text -2 thru -1 of ("0" & min) & text -2 thru -1 of ("0" & s)
set datePrettyStr to (y as text) & "-" & text -2 thru -1 of ("0" & m) & "-" & text -2 thru -1 of ("0" & d)
set timePrettyStr to text -2 thru -1 of ("0" & h) & ":" & text -2 thru -1 of ("0" & min) & ":" & text -2 thru -1 of ("0" & s)

-- Strings
set btnStart to "Start"
set btnQuit to "? Exit"
set btnAccept to "Yes"
set btnDeny to "No"
set btnCancel to "Skip"
set btnConfirm to "Save"
set btnSelect to "Confirm"
set btnLaunch to "Run macOS Scripted Setup"
set titleWelcome to "macOS Scripted Setup - Settings Helper"
set textWelcome to "This wizard guides you step-by-step through automatic creation of a Çconfig.shÈ-file to use with the macOS Scripted Setup later."
set textBackupSuccess to "Created Backup of previous User Configuration file!" & return & return & "Saved as:"
set textSaveSuccess to "Configuration saved!" & return & return & "config.sh is ready. You can now run the installation script."
set textSaveError to "Error saving config:" & return
set textExit to "Your custom configuration file was saved!"
set textExitContinue to "Want to start the macOS Scripted Setup directly?"
set textRerunSetup to "A partial installation was detected (config.rerun.sh)." & return & return & "Do you want to continue the installation, or back up the file and start the Config Wizard from scratch?"
set titleReadOnly to "Read-only Location Ñ Cannot Continue"
set textReadOnlyError to "The macOS Scripted Setup is running from a read-only location:" & return & return & scriptFolder & return & return & "Move the folder to a writable location (e.g. your Desktop or Home folder) and run the wizard again."
set textSelect to "Choose multiple entries using Command/Shift keys, or skip to ignore"
set textChoose to "Select a preferred Option, or skip to ignore"
set textAnswer to "Choose your preference"
set textInput to "Type a text into the text input, or skip to leave blank"
set titleMacSecurity to "Mac Security Hardening"
set titleSystemServices to "macOS System Services"
set titleAppsRemove to "Remove pre-installed Apps from Apple"
set titleAppsFoundation to "Install Application Support Tools"
set titleAppsFinderExtensions to "Install Finder Extensions"
set titleAppsProductivity to "Install Productivity Apps"
set titleAppsMessaging to "Install Messaging Apps"
set titleAppsGaming to "Install Gaming Apps"
set titleAppsWebbrowser to "Install additional Webbrowsers"
set titleAppsDevelopment to "Install Developer Tools"
set titleAppsDevelopmentWeb to "Install Web Development Tools"
set titleCustomizeMacOS to "Customize macOS Look+Feel"
set titleCustomizeTextinput to "Customize Text inputs"
set titleCustomizeKeyboardMouse to "Customize Keyboard and Mouse/Trackpad"
set titleCustomizeFinder to "Customize Finder"
set titleCustomizeScreenshots to "Customize Screen Capture"
set titleCustomizeAppleApps to "Customize Apple Apps"
set titleCustomizeUserhome to "Add custom User Home Folders"
set titleCustomizeWallpapers to "Add custom Wallpapers"
set titleCustomizePerformance to "Optimize macOS Performance"
set titleCustomizeSafari to "Customize Safari Webbrowser and install Safari Extensions"
set titleCustomizeTerminal to "Customize Terminal App"
set titleCustomizeNightshift to "Enable Night Shift (warmer display tone during evening and night)"


-- ==================================================
-- Welcome Screen
-- ==================================================
display dialog textWelcome with title titleWelcome buttons {btnQuit, btnStart} default button btnStart cancel button btnQuit with icon note
if the button returned of the result is btnQuit then
	-- Quit Script
	return
end if

-- Check write access to script folder before proceeding
try
	do shell script "test -w " & quoted form of scriptFolder
on error
	display alert titleReadOnly message textReadOnlyError as critical buttons {btnQuit}
	return
end try


-- ==================================================
-- Config Setup
-- ==================================================
-- Backup existing config files
my step("Checking to backup existing config files...")

-- Check file existence: coercing to alias throws if the file is absent, succeeds if present
set configExists to false
try
	set configExists to ((POSIX file configPath) as alias) is not missing value
end try
set rerunExists to false
try
	set rerunExists to ((POSIX file configRerunPath) as alias) is not missing value
end try

tell application "System Events"
	-- User defined config.sh
	if configExists then
		tell me to set progress additional description to "Backing up existing config.sh..."
		try
			set backupName to "config-" & dateStr & "_" & timeStr & ".sh"
			set name of file configPath to backupName
			display notification textBackupSuccess & backupName with title titleWelcome sound name "Tink"
		end try
	end if
	-- Partial installation statefile config.rerun.sh
	if rerunExists then
		tell me
			set rerunChoice to display dialog textRerunSetup with title titleWelcome Â
				buttons {"Back up & Start Wizard", btnLaunch} default button btnLaunch
			if button returned of rerunChoice is btnLaunch then
				set setupPath to quoted form of scriptFolder as text
				tell application "Terminal"
					reopen
					activate
					do script ("cd " & setupPath & " && chmod +x ./run.sh && ./run.sh") in window 1
				end tell
				return
			end if
		end tell
		tell me to set progress additional description to "Backing up existing config.rerun.sh..."
		try
			set backupRerunName to "config.rerun-" & dateStr & "_" & timeStr & ".sh"
			set name of file configRerunPath to backupRerunName
			display notification textBackupSuccess & backupRerunName with title titleWelcome sound name "Tink"
		end try
	end if
end tell

-- Init new Config
my output("#!/usr/bin/env zsh" & return)


-- --------------------------------------------------
-- macOS System Services
-- --------------------------------------------------
my output("# ------------------------------")
my output("#  macOS System Services")
my output("# ------------------------------")

-- Security
my output("# -- Security --")
my step(titleMacSecurity)
set listLabels to {"FileVault: Enable Disk Encryption?", "Networking: Enable built-in Firewall?", "Login: Disable Shutdown/Restart buttons?", "Screensaver: Require password immediately?", "System Updates: Enable automatic download & install?", "Startup: Play Sound when starting Mac?"}
set listValues to {"useFileVault", "enableFirewall", "disableShutdownRestartInLogin", "enableScreensaverPassword", "playMacStartupSound", "installSystemUpdates"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels Â
		with title titleMacSecurity with prompt titleMacSecurity & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- System Settings
my output("# -- System Settings --")

my step("Enable AirDrop")
my output("enableWiredAirDrop=" & my yn(button returned of Â
	(display dialog "Enable AirDrop over wired network-connections?" with title titleSystemServices buttons {btnDeny, btnAccept} default button btnAccept)))

my step("Time Machine")
my output("speedupTimemachine=" & my yn(button returned of Â
	(display dialog "Speed up Time Machine backups?" with title titleSystemServices buttons {btnDeny, btnAccept} default button btnAccept)))

my step("Application performance")
my output("betterApplicationPerformance=" & my yn(button returned of Â
	(display dialog "Better Application performance? (e.g. disables App Nap)" with title titleSystemServices buttons {btnDeny, btnAccept} default button btnAccept)))


-- --------------------------------------------------
-- Application Installations
-- --------------------------------------------------
my output("# ------------------------------")
my output("#  Application installations")
my output("# ------------------------------")

-- Remove pre-installed Apps
my output("# -- Remove pre-installed Apps --")
my step(titleAppsRemove)
set listLabels to {"GarageBand", "iMovie"}
set listValues to {"removeGarageband", "removeiMovie"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels default items listLabels Â
		with title titleAppsRemove with prompt titleAppsRemove & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Required Applications
my output("# -- App installation Tools --")
my step(titleAppsFoundation)
set listLabels to {"Xcode Command Line Tools", "Homebrew", "Mac App Store CLI (mas)", "Rosetta 2 (Intel app compatibility)"}
set listValues to {"installXcodeTools", "installHomebrew", "installAppStoreApps", "installRosetta"}
set listDefaults to {"Xcode Command Line Tools", "Homebrew", "Mac App Store CLI (mas)"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels Â
		default items {"Xcode Command Line Tools", "Homebrew", "Mac App Store CLI (mas)"} Â
		with title titleAppsFoundation with prompt titleAppsFoundation & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Finder Extensions
my output("# -- Install Finder Extensions --")
my step(titleAppsFinderExtensions)
my output("installKeka=" & my yn(button returned of Â
	(display dialog "Install ÇKekaÈ file archive utility (better ZIP, etc.)?" with title titleAppsFinderExtensions buttons {btnDeny, btnAccept} default button btnAccept)))

my output("installQuickLookPlugins=" & my yn(button returned of Â
	(display dialog "Install Quick Look plugins?" with title titleAppsFinderExtensions buttons {btnDeny, btnAccept} default button btnAccept)))


-- Applications: Productivity
my output("# -- Install Applications --")
my step(titleAppsProductivity)
set listLabelsUtilities to {"1Password", "AlDente (MacBook battery limiter)", "Beyond Compare", "eqMac audio equalizer", "Figma", "GrandPerspective disk usage", "LinearMouse", "Macs Fan Control", "Microsoft Office", "Notion", "OverSight (mic/camera protection)", "Pixelmator Pro", "Sentinel (App Quarantine remover)", "Spotify", "Strongbox password manager", "Transmission BitTorrent", "Tresorit", "VLC Media Player", "Xnapper Screen Capture"}
set listValuesUtilities to {"install1Password", "installAlDente", "installBeyondCompare", "installEqMac", "installFigma", "installGrandPerspective", "installLinearMouse", "installMacsFanControl", "installMicrosoftOffice", "installNotion", "installOverSight", "installPixelmator", "installSentinel", "installSpotify", "installStrongbox", "installTransmission", "installTresorit", "installVLC", "installXnapper"}
set listDefaultsUtilities to {"1Password", "Beyond Compare", "LinearMouse", "Macs Fan Control", "OverSight (mic/camera protection)", "Sentinel (App Quarantine remover)", "Spotify", "Strongbox password manager", "VLC Media Player"}
my generateSection(listLabelsUtilities, listValuesUtilities, Â
	(choose from list listLabelsUtilities Â
		default items {"1Password", "Beyond Compare", "LinearMouse", "Macs Fan Control", "OverSight (mic/camera protection)", "Sentinel (App Quarantine remover)", "Spotify", "Strongbox password manager", "VLC Media Player"} Â
		with title titleAppsProductivity with prompt titleAppsProductivity & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Applications: Messaging
my step(titleAppsMessaging)
set listLabelsMsg to {"Discord", "Halloy IRC", "Telegram"}
set listValuesMsg to {"installDiscord", "installHalloyIRC", "installTelegram"}
my generateSection(listLabelsMsg, listValuesMsg, Â
	(choose from list listLabelsMsg Â
		with title titleAppsMessaging with prompt titleAppsMessaging & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Applications: Mac Gaming
my output("# -- Install Mac Gaming Apps --")
my step(titleAppsGaming)
set listLabelsGaming to {"Heroic Games Launcher", "Steam"}
set listValuesGaming to {"installHeroicGamesLauncher", "installSteam"}
my generateSection(listLabelsGaming, listValuesGaming, Â
	(choose from list listLabelsGaming Â
		with title titleAppsGaming with prompt titleAppsGaming & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Applications: Web Browsers
my output("# -- Install Web Browsers --")
my step(titleAppsWebbrowser)
set listLabelsWeb to {"Brave", "Mozilla Firefox", "Google Chrome"}
set listValuesWeb to {"installBraveBrowser", "installFirefoxBrowser", "installGoogleChromeBrowser"}
my generateSection(listLabelsWeb, listValuesWeb, Â
	(choose from list listLabelsWeb Â
		with title titleAppsWebbrowser with prompt titleAppsWebbrowser & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Safari
my output("# -- Install Safari Extensions and Safari Settings --")
my step(titleCustomizeSafari)
set listLabelsSafari to {"AdGuard for Safari", "Bonjour Startpage for Safari"}
set listValuesSafari to {"installAdGuardSafari", "installBonjourrStartpageForSafari"}
my generateSection(listLabelsSafari, listValuesSafari, Â
	(choose from list listLabelsSafari default items listLabelsSafari Â
		with title titleCustomizeSafari with prompt titleCustomizeSafari & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))
my output("secureSafariBrowser=" & my yn(button returned of Â
	(display dialog "Safari Browser: harden security settings?" with title titleCustomizeSafari buttons {btnDeny, btnAccept} default button btnAccept)))

-- Applications: Development
my output("# -- Install Developer Tools --")
my step(titleAppsDevelopment)
set listLabelsDev to {"Boop (conversion tool)", "Fork (Git client)", "Nova IDE", "Visual Studio Code", "Warp terminal"}
set listValuesDev to {"installBoop", "installFork", "installNova", "installVisualStudioCode", "installWarp"}
my generateSection(listLabelsDev, listValuesDev, Â
	(choose from list listLabelsDev Â
		with title titleAppsDevelopment with prompt titleAppsDevelopment & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Development Tools: Git
my output("# -- Install Git --")
my step("Git configuration...")
set installGit to display dialog "Install and use Git?" with title titleAppsDevelopment buttons {btnDeny, btnAccept} default button btnAccept
my output("installGit=" & my yn(button returned of installGit))
if button returned of installGit is btnAccept then
	try
		my output("gitUsername='" & text returned of (display dialog "Git display name (shown in commits):" default answer "" buttons {btnConfirm} default button btnConfirm) & "'")
	end try
	try
		my output("gitUseremail='" & text returned of (display dialog "Git email address (shown in commits):" default answer "" buttons {btnConfirm} default button btnConfirm) & "'")
	end try
end if

-- Web Development Suite
my output("# -- Install Web Development Suite --")
my step("Docker configuration...")
set installDocker to display dialog "Install Docker, MAMP, or neither?" with title titleAppsDevelopment buttons {btnCancel, "MAMP", "Docker"}
if button returned of installDocker is "MAMP" then
	my output("installDocker=false")
	my output("installMAMP=true")
else if button returned of installDocker is "Docker" then
	my output("installMAMP=false")
	my output("installDocker=true")
	my output("useOrbStackOverDocker=" & my yn(button returned of Â
		(display dialog "Use OrbStack instead of Docker?" with title titleAppsDevelopment buttons {btnDeny, btnAccept} default button btnAccept)))
else
	my output("installMAMP=false")
	my output("installDocker=false")
end if

my step(titleAppsDevelopmentWeb)
set installWebdevTools to display dialog "Web Development Tools required?" with title titleAppsDevelopmentWeb buttons {btnDeny, btnAccept}
if button returned of installWebdevTools is btnAccept then
	my output("installWebdevTools=true")
	set listLabelsWebdev to {"Composer + local PHP", "Gas Mask (hosts file manager)", "Hedit (hosts file manager)", "Node.js", "Sequel Ace (DB Manager)", "SonarQube"}
	set listValuesWebdev to {"installComposer", "installGasMask", "installHedit", "installNodejs", "installSequelAce", "installSonarQube"}
	my generateSection(listLabelsWebdev, listValuesWebdev, Â
		(choose from list listLabelsWebdev default items {"Composer + local PHP", "Hedit (hosts file manager)", "Sequel Ace (DB Manager)"} Â
			with title titleAppsDevelopment with prompt titleAppsDevelopment & return & return & textSelect Â
			cancel button name btnCancel OK button name btnSelect Â
			with multiple selections allowed and empty selection allowed))
else
	my output("installWebdevTools=false")
	my output("installComposer=false")
	my output("installGasMask=false")
	my output("installHedit=false")
	my output("installNodejs=false")
	my output("installSequelAce=false")
	my output("installSonarQube=false")
end if


-- --------------------------------------------------
-- User and App Settings
-- --------------------------------------------------
my output("# ------------------------------")
my output("#    User and App Settings")
my output("# ------------------------------")

-- macOS Look+Feel and Window handling
my output("# -- macOS Look and Feel --")
my step(titleCustomizeMacOS)
set listLabels to {"Always show Scroll Bars", "Disable transparency/blur effects", "Full draggable windows (click anywhere in window to drag)", "Mission Control: Enable Hot Corners"}
set listValues to {"showScrollbars", "disableTransparency", "enableFullDraggableWindows", "useMissionControl"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels default items {"Always show Scroll Bars", "Mission Control: Enable Hot Corners"} Â
		with title titleCustomizeMacOS with prompt titleCustomizeMacOS & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Menu Bar
my output("# -- Menu Bar --")
my step(titleCustomizeMacOS)
set listLabels to {"Show Battery % (MacBooks only)", "Show Date & Time", "Show Fast User Switching"}
set listValues to {"showBatteryPercentage", "dateTimeInMenubar", "enableFastUserswitching"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels default items {"Show Date & Time"} Â
		with title titleCustomizeMacOS with prompt titleCustomizeMacOS & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Dock
my output("# -- Dock --")
my step(titleCustomizeMacOS)
set listLabels to {"Speed up Dock animations", "Apply Dock visual improvements", "Minimal Dock (removes default Apple apps)"}
set listValues to {"speedupDock", "beautifyDock", "minimalDock"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels Â
		with title titleCustomizeMacOS with prompt titleCustomizeMacOS & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Displays Settings
my output("# -- Displays Settings --")
my step(titleCustomizeMacOS)
my output("enableAllResolutions=" & my yn(button returned of Â
	    (display dialog "Show full list of supported Display resolutions in Settings?" with title titleCustomizeMacOS buttons {btnDeny, btnAccept} default button btnAccept)))
my output("enableNightShift=" & my yn(button returned of Â
	    (display dialog "Enable Night Shift (warmer display tone after sunrise)?" with title titleCustomizeMacOS buttons {btnDeny, btnAccept} default button btnAccept)))

-- Text, Keyboard, Mouse & Trackpad Handling
my output("# -- Text, Keyboard, Mouse & Trackpad Handling --")
my step(titleCustomizeKeyboardMouse)
set listLabels to {"Text: Disable Auto-Corrections", "Text: Disable replacing double-scpaces with period (.)", "Disable Natural Scrolling", "Speed-up Mouse Cursor", "Keyboard: TAB-key cycle through all elements", "Trackpad: Tap to Click (MacBooks only)"}
set listValues to {"disableAnnoyingTextcorrections", "disableDoubleSpacePeriod", "disableNaturalScrolling", "fasterMouseCursor", "enableTabFocusChange", "enableTrackpadClicks"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels default items {"Text: Disable Auto-Corrections", "Disable Natural Scrolling", "Speed-up Mouse Cursor"} Â
		with title titleCustomizeKeyboardMouse with prompt titleCustomizeKeyboardMouse & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))
-- Fn/Globe Key
set fnKeyValue to choose from list {"off Ñ Do nothing", "dictation Ñ Start Dictation", "emoji Ñ Emojis & Symbols", "language Ñ Switch Input Sources"} Â
	default items {"emoji Ñ Emojis & Symbols"} Â
		with title titleCustomizeKeyboardMouse with prompt "What should the Fn/Globe key do?" & return & return & textChoose Â
		cancel button name btnCancel OK button name btnSelect
if fnKeyValue is false then
	my output("fnKeyFunction=off")
else
	my output("fnKeyFunction=" & word 1 of (item 1 of fnKeyValue))
end if

-- Finder (gated section)
my output("# -- Finder customizations --")
my step(titleCustomizeFinder)
set customizeFinder to display dialog "Customize Finder settings?" with title titleCustomizeFinder buttons {btnDeny, btnAccept} default button btnAccept
if button returned of customizeFinder is btnAccept then
	my output("customizeFinder=true")
	my output("showFileExtensions=" & my yn(button returned of Â
	    (display dialog "Show file extensions in Finder?" with title titleCustomizeFinder buttons {btnDeny, btnAccept} default button btnDeny)))
	my output("showPathInFinder=" & my yn(button returned of Â
	    (display dialog "Show full file path in Finder window titles?" with title titleCustomizeFinder buttons {btnDeny, btnAccept} default button btnDeny)))
	my output("removeTrashbinItemsPeriodically=" & my yn(button returned of Â
	    (display dialog "Auto-remove Trash items after 30 days?" with title titleCustomizeFinder buttons {btnDeny, btnAccept} default button btnAccept)))
else
	my output("customizeFinder=false")
	my output("showFileExtensions=false")
	my output("showPathInFinder=false")
	my output("removeTrashbinItemsPeriodically=false")
end if

-- Screen Capture
my output("# -- Screen Capture Settings --")
my step(titleCustomizeScreenshots)
set listLabels to {".bmp", ".gif", ".heic", ".jp2", ".jpg", ".pdf", ".pict", ".png", ".tga", ".tiff"}
set listValues to {"bmp", "gif", "heic", "jp2", "jpg", "pdf", "pict", "png", "tga", "tiff"}
set selectedFormat to choose from list listLabels default items {".png"} Â
	with title titleCustomizeScreenshots with prompt titleCustomizeScreenshots & return & return & textAnswer Â
	cancel button name btnCancel OK button name btnSelect
if selectedFormat is false then
	my output("useScreenshotsFormat='png'")
else
	set selectedLabel to item 1 of selectedFormat as text
	set formatValue to "png"
	repeat with i from 1 to count of listLabels
		if (item i of listLabels as text) is selectedLabel then
			set formatValue to item i of listValues as text
			exit repeat
		end if
	end repeat
	my output("useScreenshotsFormat='" & formatValue & "'")
end if
my output("useScreenshotsNumericFilename=" & my yn(button returned of Â
    (display dialog "Use numeric Filenames for Screenshots?" & return & "(Default: Screenshot with date & time)" with title titleCustomizeScreenshots buttons {btnDeny, btnAccept} default button btnDeny)))

-- Apple Apps
my output("# -- Apple Apps --")
my output("useRealNamesForContacts=" & my yn(button returned of Â
    (display dialog "Contacts: use Real Names (not Nicknames)?" & return & return & textAnswer with title titleCustomizeAppleApps buttons {btnDeny, btnAccept} default button btnAccept)))
my output("showSubjectInMessagesApp=" & my yn(button returned of Â
    (display dialog "Messages: show Subject field in Messages app?" & return & return & textAnswer with title titleCustomizeAppleApps buttons {btnDeny, btnAccept} default button btnDeny)))
my output("showMusicNextSongPlaying=" & my yn(button returned of Â
    (display dialog "Music: show Notification for next Song playing?" & return & return & textAnswer with title titleCustomizeAppleApps buttons {btnDeny, btnAccept} default button btnDeny)))

-- User Home
my output("# -- User Home folder --")
my step(titleCustomizeUserhome)
set listLabels to {"Show ~/Library in Userhome", "Add User ~/Applications folder", "Add User ~/Games folder", "Add User ~/Sites folder"}
set listValues to {"showLibraryFolder", "addUserApplicationsFolder", "addUserWebsitesFolder", "addUserGamesFolder"}
my generateSection(listLabels, listValues, Â
	(choose from list listLabels default items {"Show ~/Library in Userhome", "Add User ~/Applications folder"} Â
		with title titleCustomizeUserhome with prompt titleCustomizeUserhome & return & return & textSelect Â
		cancel button name btnCancel OK button name btnSelect Â
		with multiple selections allowed and empty selection allowed))

-- Wallpapers
my output("# -- Wallpapers (Desktop Pictures) --")
my step(titleCustomizeWallpapers)
set downloadWallpapers to display dialog "Download community Wallpapers?" with title titleCustomizeWallpapers buttons {btnDeny, btnAccept} default button btnAccept
if button returned of downloadWallpapers is btnAccept then
	my output("downloadWallpapers=true")
	set listLabels to {"Desert", "Exodus", "Fuji", "Fluted", "Hivemind"}
	set listValues to {"dynamicWallpaperDesert", "dynamicWallpaperExodus", "dynamicWallpaperFuji", "dynamicWallpaperFluted", "dynamicWallpaperHivemind"}
	my generateSection(listLabels, listValues, Â
		(choose from list listLabels default items {"Desert", "Exodus"} Â
			with title titleCustomizeWallpapers with prompt titleCustomizeWallpapers & return & return & textSelect Â
			cancel button name btnCancel OK button name btnSelect Â
			with multiple selections allowed and empty selection allowed))
else
	my output("downloadWallpapers=false")
	my output("dynamicWallpaperDesert=false")
	my output("dynamicWallpaperExodus=false")
	my output("dynamicWallpaperFuji=false")
	my output("dynamicWallpaperFluted=false")
	my output("dynamicWallpaperHivemind=false")
end if

-- Terminal
my output("# -- Terminal --")
my step(titleCustomizeTerminal)
my output("enableTerminalUtf8=" & my yn(button returned of Â
    (display dialog "Enable UTF-8 in Terminal?" with title titleCustomizeTerminal buttons {btnDeny, btnAccept} default button btnAccept)))
-- Terminal Custom Theme and Configurations DISABLED in Settings Helper
my output("useCustomTerminalTheme=false")
my output("useCustomTerminalThemeURL=''")
my output("useCustomTerminalConfigurations=false")
my output("useCustomTerminalConfigurationsURL=''")


-- ==================================================
-- Save custom Config
-- ==================================================
my output(return & "# ------------------------------")
my output("# config.sh - Generated by Settings Helper on " & datePrettyStr & " " & timePrettyStr)
try
	set configFile to open for access POSIX file configPath with write permission
	set eof of configFile to 0
	write configContent to configFile
	close access configFile
	display notification textSaveSuccess with title titleWelcome sound name "Tink"
on error errMsg
	beep
	display alert "Error saving config:" & errMsg buttons {btnQuit}
	try
		close access POSIX file configPath
	end try
	-- Quit Script
	return
end try


-- ==================================================
-- Make ./run.sh executable
-- ==================================================
try
	do shell script "chmod +x " & quoted form of (scriptFolder & "run.sh")
end try


-- ==================================================
-- Exit Screen
-- ==================================================
my step(textExit)
set runInstallation to display alert textExit message textExitContinue as informational Â
	buttons {btnQuit, btnLaunch} cancel button btnQuit
if button returned of runInstallation is btnLaunch then
	set setupPath to quoted form of scriptFolder as text
	tell application "Terminal"
		reopen
		activate
		set shell to do script ("cd " & setupPath & " && chmod +x ./run.sh && ./run.sh") in window 1
	end tell
else
	-- Quit Script
	return
end if


-- ==================================================
-- AppleScript Function Handlers
-- ==================================================
-- Convert Yes/No button result to true/false string
on yn(buttonResult)
	if buttonResult is "Yes" then return "true"
	return "false"
end yn

-- Output handler to add single Line string to configContent property
on output(textStringLine)
	set configContent to configContent & textStringLine & linefeed
end output

-- Iterate parallel label/var lists; write varName=true if label was selected, false otherwise.
-- Handles both false (Cancel) and {} (OK with nothing checked) from choose from list.
on generateSection(labelList, varList, selectedItems)
	set out to ""
	repeat with i from 1 to count of labelList
		set lbl to item i of labelList as text
		set var to item i of varList as text
		set isSelected to false
		if selectedItems is not false then
			repeat with sel in selectedItems
				if (sel as text) is lbl then
					set isSelected to true
					exit repeat
				end if
			end repeat
		end if
		if isSelected then
			-- set out to out & var & "=true" & return
			my output(var & "=true")
		else
			-- set out to out & var & "=false" & return
			my output(var & "=false")
		end if
	end repeat
	-- return out
end generateSection

-- Update Progress
on step(descriptionText)
    set configStepsCompleted to configStepsCompleted + 1
    set progress completed steps to configStepsCompleted
    set progress additional description to descriptionText
end step
