#!/usr/bin/env zsh

function installAppFigma(){
    # --> Download
    downloadFromUrl "https://www.figma.com/download/desktop/mac" "Figma.dmg"
    # --> Mount & move
    unmountFile "Figma.dmg" "Figma"
    moveApplication "Figma.app"
    # --> Configure App
    configureAppFigma
}
export -f installAppFigma

function configureAppFigma(){
    # Prevent Figma from adding the FigmaAgent to Login Items
    # - Source: https://stackoverflow.com/a/75897908/5750030

    # 1) Removing FigmaAgent.app
    # (obsolete as Figma may not have been started yet)
    #rm -fr ~/Library/Application\ Support/Figma/FigmaAgent.app

    # 2) Replace it with a dummy file
    touch ~/Library/Application\ Support/Figma/FigmaAgent.app

    # --> Notify
    notify

    # 3) Make the dummy file undeletable (so this works across Figma.app updates)
    sudo chflags -R schg ~/Library/Application\ Support/Figma/FigmaAgent.app
}
export -f configureAppFigma
