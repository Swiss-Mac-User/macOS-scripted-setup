#!/usr/bin/env zsh

# -- AirDrop --
# --> Enable AirDrop over Ethernet and on unsupported Macs running Lion
function enableAirDropOnEthernet(){
    defaults write com.apple.NetworkBrowser "BrowseAllInterfaces" -bool TRUE
}
export -f enableAirDropOnEthernet
