#!/usr/bin/env zsh

# Install GnuPG to enable PGP-signing commits.
function brewinstallAppGnuPG(){
    brew install gnupg
}
export -f brewinstallAppGnuPG
