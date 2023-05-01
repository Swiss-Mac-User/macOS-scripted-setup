Automate your macOS setup
===

**Welcome to the macOS Scripted Setup!<br>This project helps Mac users quickly and easily set up a new computer or useraccount by automatically configuring a range of system settings and installing commonly used applications.**

## What is this?

![Screenshot of macOS Scripted Setup in action](Swiss-Mac-User/macOS-scripted-setup/blob/installer/README_demo.png?raw=true)

The script is easy to use and can be run directly from the Terminal application, as a regular user or admin user. It automatically performs a series of commands to change default macOS settings and download applications. It's designed to be widely backward and forward compatible with various macOS versions.

**All settings can be configured!** Some features include enabling the firewall, setting better security features, customising the Finder, Dock, and Mission Control for better productivity; and many more. Additionally, the script installs applications such as browsers, media players, productivity apps, and web development tools.

The macOS Scripted Setup is **perfect for users who want to save time and avoid the hassle of manually changing settings and installing apps**. The whole project, but particularly the configuration file, is **portable** - so you can keep them on a USB-stick for the next Mac setup. Give it a try and streamline your new Mac setup process!

## How to use

### Download macOS Scripted Setup

* Download & extract «Source code (zip)» [from Releases](/Swiss-Mac-User/macOS-scripted-setup/releases) to your ~/Downloads/ folder

### Configure your preferences

1. Duplicate the file `/macOS-scripted-setup/config.default.sh` as `config.sh`

2. Open `config.sh` with TextEdit

3. …and change all settings to your personal preferences, using `true`/`false`.<br>(Note: if no `config.sh` is present, it will fall back to the default configs)

### Start the scripted Setup

Maybe now is the time to go and get a coffee ☕️…

1. Open the «Terminal.app» from Applications » Utilities

2. Paste the following command to the Terminal.app, and start the setup by pressing `Return`:

```bash
cd ~/Downloads/macOS-scripted-setup/ && chmod +x ./run.sh && ./run.sh
```
Watch the magic happen… and occasionally interact when instructions show up (e.g. sign-in on the Mac App Store-App).

#### That's it - happy installation! :)

<sub>P.s.: the scripts were tested successfully on Apple Silicon Mac and macOS 13 Ventura.</sub>


## Requests for changes

### Issues and feature requests
Report an [Issue](/Swiss-Mac-User/macOS-scripted-setup/issues) or start a [new Discussion](/Swiss-Mac-User/macOS-scripted-setup/discussions) for feedback or help.

### Contributions
Feel free to [fork this project](/Swiss-Mac-User/macOS-scripted-setup/fork) and add Pull Requests for any suggested changes or additions!



## Advanced settings

If you want to run additional bash commands as part of the setup, you can duplicate the template-file `mycommands.template.sh` as `mycommands.sh`, and populate it with any commands. These custom commands will be executed LAST in the whole setup (see the `run.sh` file).

---

## Inspiration and Kudos

A **BIG «THANK YOU»** to these inspiring and helfpful sources! 🫶 Make sure to check them out and leave a kudos.

* Yann Bertrand's awesome work with «[macOS-defaults](yannbertrand/macos-defaults)»
* Patrick Force's approach with «[macOSa](rockholla/macosa)» (which was a bit too complex for my use case…)
* Ryan Pavlick's helpful «[add_to_dock](ryanpavlick/add_to_dock)» bash scripts
* Mathias Bynens's epic «[dotfiles](mathiasbynens/dotfiles)» (particularly its [.macos](mathiasbynens/dotfiles/blob/main/.macos))!
* MacRumors «[Dock to Show Running Apps Only](https://www.macrumors.com/how-to/macos-dock-show-active-apps/)», Ask Different «[identify if Filevault is enabled](https://apple.stackexchange.com/q/70969/86244)» and «[Check if OS X user is Administrator](https://apple.stackexchange.com/a/179531/86244)»
