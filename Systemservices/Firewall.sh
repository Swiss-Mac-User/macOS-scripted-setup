#!/usr/bin/env zsh

# -- Built-in Firewall (com.apple.alf.plist) --
# --> Enable Stealth mode
function activateFirewallStealthmode(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
    else
        echo "'activateFirewallStealthmode' requires system administrator or root privileges. Run with an admin user, or using sudo."
    fi
}
export -f activateFirewallStealthmode

# --> Enable built-in Firewall
function enableFirewall(){
    # Requires Admin privileges
    if checkIfUserIsAdmin; then
        # --> Notify first
        notify
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
    else
        echo "'enableFirewall' requires system administrator or root privileges. Run with an admin user, or using sudo."
    fi
}
export -f enableFirewall
