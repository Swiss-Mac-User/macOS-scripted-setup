#!/usr/bin/env zsh

# Set Global Git settings
function setGitconfigs(){
	# Git Username
	if checkIfNotEmpty "$gitUsername"; then
		git config --global user.name $gitUsername
	fi

	# Git User Email
	if checkIfNotEmpty "$gitUseremail"; then
		git config --global user.email $gitUseremail
	fi

	# Enable Git password caching
	git config --global credential.helper osxkeychain

	# Make `git pull` only in fast-forward mode
	git config --global pull.ff only

	setGitignore
}
export -f setGitconfigs

# Set Global Gitignore list
function setGitignore(){
	# Add global ignore list
	# --> Download
	downloadFromUrl "https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore" "gitignore.txt"
	# --> Move to $HOME and configure in git
	mv "$HOME/Downloads/gitignore.txt" "$HOME/.gitignore"
	git config --global core.excludesfile $HOME/.gitignore

	# Extend global ignore list
	echo "" >> $HOME/.gitignore
	echo "# Third-party Application files and folder" >> $HOME/.gitignore
	echo ".nova/" >> $HOME/.gitignore
}
export -f setGitignore
