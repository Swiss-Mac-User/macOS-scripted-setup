#!/usr/bin/env zsh

function enableTextEditPlaintext(){
    # Use plain text mode for new TextEdit documents
    defaults write com.apple.TextEdit "RichText" -int 0

    # Open and save files as UTF-8 in TextEdit
    defaults write com.apple.TextEdit "PlainTextEncoding" -int 4
    defaults write com.apple.TextEdit "PlainTextEncodingForWrite" -int 4
}

# Text, disable auto-correct
function disableTextAutocorrect(){
    defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool FALSE
    defaults write NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled" -bool FALSE
}
export -f disableTextAutocorrect

# Text, disable automatic capitalisation
function disableTextCapitalisation(){
    defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool FALSE
}
export -f disableTextCapitalisation

# Text, disable automatic period substitution
function disableTextPeriodSubstitution(){
    defaults write NSGlobalDomain "NSAutomaticPeriodSubstitutionEnabled" -bool FALSE
}
export -f disableTextPeriodSubstitution
