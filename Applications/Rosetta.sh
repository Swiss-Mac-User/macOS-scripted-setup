#!/usr/bin/env zsh

function installAppRosetta(){
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license > /dev/null
}
export -f installAppRosetta
