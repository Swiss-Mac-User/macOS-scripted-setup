#!/usr/bin/env zsh

# -- Userhome files --
# --> Create .zprofile ZSH Shell configuration file
function createUserFileZprofile(){
    local zprofilePath="$HOME/.zprofile"

    if touch "$zprofilePath" > /dev/null 2>&1; then
        showinfo "Added $zprofilePath" "confirm"
    else
        showinfo "Already exists $zprofilePath" "note"
    fi
}
export -f createUserFileZprofile
