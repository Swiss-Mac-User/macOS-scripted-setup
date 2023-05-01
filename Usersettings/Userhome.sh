#!/usr/bin/env zsh

# -- Userhome Files + Folders --
# --> Unhide Library folder
function showUserhomeLibraryFolder(){
    chflags nohidden $HOME/Library
    #xattr -d com.apple.FinderInfo ~/Library # errors: No such xattr: com.apple.FinderInfo
}
export -f showUserhomeLibraryFolder
