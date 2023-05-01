#!/usr/bin/env zsh

# -- Screenshots settings --
# --> Don't add DateTime to Screenshot files
function useNumericScreenshots(){
    defaults write com.apple.screencapture "include-date" -bool FALSE
}
export -f useNumericScreenshots

# --> Use different image format for Screenshots
# Supported file types: png (default), bmp, gif, heic, jpg, jp2, tif, pict, pdf, tga, tiff
function saveScreenshotsAs(){
    local changeFormat=false
    case "$ScreenshotsImageFormat" in
        png) changeFormat=false;;
        bmp|gif|heic|jpg|jp2|tif|pict|pdf|tga|tiff) changeFormat="$ScreenshotsImageFormat";;
        *) changeFormat=false;;
    esac

    # Screenshot format is valid and not default (png):
    if [ ! "$changeFormat" ]; then
        defaults write com.apple.screencapture "type" -string "$changeFormat"
    fi
}
export -f saveScreenshotsAs

# --> Restart SystemUIServer
function restartSystemUIServer(){
    killall SystemUIServer
}
export -f restartSystemUIServer
