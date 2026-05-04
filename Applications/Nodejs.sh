#!/usr/bin/env zsh

# -- Install Node.js --
# Source: https://changelog.com/posts/install-node-js-with-homebrew-on-os-x
function brewinstallAppNodejs(){
    # --> Installation
    brew install node
    # --> Install Grunt
    brewinstallAppNpmGrunt
}
export -f brewinstallAppNodejs

# -- Install Grunt via npm --
# Source: https://changelog.com/posts/install-node-js-with-homebrew-on-os-x
function brewinstallAppNpmGrunt(){
    # --> Installation
    npm install -g grunt-cli
}
export -f brewinstallAppNpmGrunt
