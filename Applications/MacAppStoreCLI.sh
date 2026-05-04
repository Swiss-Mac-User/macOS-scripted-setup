#!/usr/bin/env zsh

# -- Mac App Store Command-Line Client --
# --> Install mas
function brewinstallAppMacAppStoreCLI(){
	# --> Installation
	brew install mas
	# --> Trigger App Store sign-in
	configureAppMacAppStore
}
export -f brewinstallAppMacAppStoreCLI

# --> Check if User has authenticated to App Store
function checkIfAppStoreAuthenticated(){
    if ! command -v mas &> /dev/null; then
        return 1 # false: mas not installed
    fi
    if mas outdated --accurate > /dev/null 2>&1; then
        return 0 # true: authenticated
    else
        return 1 # false: not authenticated
    fi
}
export -f checkIfAppStoreAuthenticated

# --> Mac App Store Sign-in (required for MAS to work)
function configureAppMacAppStore(){
	# --> Sign-in to App Store (mas outdated --accurate triggers the sign-in dialog)
	if ! checkIfAppStoreAuthenticated; then
		# --> Open App Store.app
		open /System/Applications/App\ Store.app
		# --> Notify about sign-in to App Store
		notify
		local retries=12 # = for 60 Seconds
		until checkIfAppStoreAuthenticated || [ "$retries" = 0 ]; do
			local BOLD=$(tput bold)
			local REGULAR=$(tput sgr0)
			local countdown=$((retries * 5))
			showinfo "Please open App Store and sign in using your Apple ID.\nSkipping this check in: ${BOLD}$countdown seconds${REGULAR}" "error"
			((retries--))
			sleep 5
		done
	fi
}
export -f configureAppMacAppStore

# --> Install pending Application Updates from App Store
function masinstallAppUpdates(){
    # Install pending Updates from App Store
    mas update --accurate --check-min-os
}
export -f masinstallAppUpdates
