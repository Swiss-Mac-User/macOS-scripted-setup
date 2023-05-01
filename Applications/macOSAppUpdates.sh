#!/usr/bin/env zsh

function masinstallAppUpdates(){
    # Install pending Updates from App Store
    mas upgrade
}
export -f masinstallAppUpdates
