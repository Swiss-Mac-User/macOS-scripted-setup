#!/usr/bin/env zsh

# -- Privacy --
# Don’t send search queries to Apple
function privateSearchQueriesInSafari(){
	defaults write com.apple.Safari "UniversalSearchEnabled" -bool FALSE
	defaults write com.apple.Safari "SuppressSearchSuggestions" -bool TRUE
	defaults write com.apple.Safari "SearchProviderShortName" -string "DuckDuckGo"
}
export -f privateSearchQueriesInSafari

# Enable “Do Not Track”
function noContentTrackingInSafari(){
	defaults write com.apple.Safari "SendDoNotTrackHTTPHeader" -bool TRUE
}
export -f noContentTrackingInSafari


# -- Security --
# Show the full URL in the address bar (note: this still hides the scheme)
function showFullUrlInSafari(){
	defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool TRUE
	defaults write com.apple.Safari "ShowOverlayStatusBar" -bool TRUE
}
export -f showFullUrlInSafari

# Prevent Safari from opening ‘safe’ files automatically after downloading
function preventUnpackingDownloadedFilesInSafari(){
	defaults write com.apple.Safari "AutoOpenSafeDownloads" -bool FALSE
}
export -f preventUnpackingDownloadedFilesInSafari

# Warn about fraudulent websites
function preventVisitingBadWebsitesInSafari(){
	defaults write com.apple.Safari "WarnAboutFraudulentWebsites" -bool TRUE
}
export -f preventVisitingBadWebsitesInSafari

# Update extensions automatically
function preventOutdatedExtensionsInSafari(){
	defaults write com.apple.Safari "InstallExtensionUpdatesAutomatically" -bool TRUE
}
export -f preventOutdatedExtensionsInSafari

# Disable AutoFill
function preventAutofillingYourDataInSafari(){
	defaults write com.apple.Safari AutoFillFromAddressBook -bool FALSE
	defaults write com.apple.Safari AutoFillPasswords -bool FALSE
	defaults write com.apple.Safari AutoFillCreditCardData -bool FALSE
	defaults write com.apple.Safari AutoFillMiscellaneousForms -bool FALSE
}
export -f preventAutofillingYourDataInSafari

# -- Website inspecting --
# Enable the Develop menu and the Web Inspector in Safari
# Web views, add a contextual menu item for showing the Web Inspector
function enableDeveloperToolsInSafari(){
	defaults write NSGlobalDomain "WebKitDeveloperExtras" -bool TRUE
	defaults write com.apple.Safari "IncludeDevelopMenu" -bool TRUE
	defaults write com.apple.Safari "WebKitDeveloperExtrasEnabledPreferenceKey" -bool TRUE
	defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool TRUE
}
export -f enableDeveloperToolsInSafari
