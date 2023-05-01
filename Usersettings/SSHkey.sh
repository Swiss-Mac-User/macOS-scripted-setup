#!/usr/bin/env zsh

# Generate SSH Key
function generateSSHKey(){
	if checkIfNotEmpty "$gitUseremail"; then
		# --> Notify
		notify
		# --> Generate SSH Key
		ssh-keygen -t rsa -C $gitUseremail
		# --> Start SSH agent
		eval "$(ssh-agent -s)"
		# --> Add SSH Config file
		touch $HOME/.ssh/config
		echo "Host *" >> $HOME/.ssh/config
		echo " AddKeysToAgent yes" >> $HOME/.ssh/config
		echo " UseKeychain yes" >> $HOME/.ssh/config
		echo " IdentityFile ~/.ssh/id_rsa" >> $HOME/.ssh/config
		# --> Add SSH key locally
		ssh-add --apple-use-keychain $HOME/.ssh/id_rsa

		# --> GitHub SSH Key config
		if checkIfNotEmpty "$gitUsername" && checkIfFileExists "$HOME/.ssh/id_rsa.pub"; then
			echo "Add this SSH Public Key on GitHub: https://github.com/settings/keys"
			# --> Notify
			notify
			pbcopy < $HOME/.ssh/id_rsa.pub
		else
			showinfo "Cannot execute: pbcopy < $HOME/.ssh/id_rsa.pub\n--> Try to run this command manually" "notice"
		fi
	else
		showinfo "No SSH Key configured, due to missing Git User Email !" "error"
	fi
}
export -f generateSSHKey
