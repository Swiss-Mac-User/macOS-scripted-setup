#!/usr/bin/env zsh

function installAppGasMask(){
    # --> Download & Unzip
    downloadFromUrl "https://github.com/2ndalpha/gasmask/releases/download/0.8.6/gas_mask_0.8.6.zip" "GasMask.zip"
    # --> Unzip
    unzipFile "GasMask.zip"
    # --> Move & open Application
    moveApplication "Gas Mask.app" "open"
}
export -f installAppGasMask
