#!/usr/bin/env zsh

# Mac App Store Command-Line Client
function brewinstallAppMacAppStoreCLI(){
	# --> Installation
	brew install mas
	# --> Trigger App Store sign-in
	configureAppMacAppStore
}
export -f brewinstallAppMacAppStoreCLI

# Mac App Store Sign-in (required for MAS to work)
function configureAppMacAppStore(){
	# --> Sign-in to App Store
	if [ ! $(checkIfAppStoreAuthenticated) ]; then
		if ! mas account > /dev/null; then
			# --> Open App Store.app
			open /System/Applications/App\ Store.app
			# --> Notify about sign-in to App Store
			notify
			local retries=12 # = for 60 Seconds
			until mas account >/dev/null || [ "$retries" = 0 ]; do
				local BOLD=$(tput bold)
				local REGULAR=$(tput sgr0)
				local countdown=$((retries * 5))
				showinfo "Please open App Store and sign in using your Apple ID. Skipping this check in: ${BOLD}$countdown seconds${REGULAR}" "error"
				((retries--))
				sleep 5
			done
		fi
	fi
}
export -f configureAppMacAppStore
