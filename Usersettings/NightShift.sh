#!/usr/bin/env zsh

# -- Night Shift (using smudge/nightlight) --
# (Source: https://github.com/smudge/nightlight)
# --> Install mas
function brewinstallAppNightlight(){
	# --> Installation
	brew install smudge/smudge/nightlight
	# --> Apply settings
	configureNightShift
}
export -f brewinstallAppNightlight


# --> Configure Night Shift temperature & schedule
function configureNightShift(){
    nightlight temp 80
    nightlight schedule start
}
export -f configureNightShift
