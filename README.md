Automate your macOS setup
===

**Welcome to the macOS Scripted Setup!<br>This project helps Mac users quickly and easily set up a new computer or useraccount by automatically configuring a range of system settings and installing commonly used applications.**

## What is this?

![Screenshot of macOS Scripted Setup in action](/README_demo.png?raw=true)

The script is easy to use and can be run directly from the Terminal application, as a regular user or admin user. It automatically performs a series of commands to change default macOS settings and download applications. It's designed to be widely backward and forward compatible with various macOS versions.

**All settings can be configured!** Some features include enabling the firewall, setting better security features, customising the Finder, Dock, and Mission Control for better productivity; and many more. Additionally, the script installs applications such as browsers, media players, productivity apps, and web development tools.

The macOS Scripted Setup is **perfect for users who want to save time and avoid the hassle of manually changing settings and installing apps**. The whole project, but particularly the configuration file, is **portable** - so you can keep them on a USB-stick for the next Mac setup. Give it a try and streamline your new Mac setup process!

## How to use

<sub>P.s.: the scripts were tested successfully on Apple Silicon Mac and macOS 13 Ventura.</sub>

### 📥 Download macOS Scripted Setup

Fast and easy download with this command in the `Terminal.app`:

```bash
curl -SL "https://github.com/Swiss-Mac-User/macOS-scripted-setup/archive/refs/heads/installer.zip" | tar xz -C "$HOME/Downloads" && open "$HOME/Downloads/macOS-scripted-setup-installer"
```

Alternatively you can manually download & extract the latest «Source code (zip)» [from Releases](/../../releases) to your `~/Downloads/` folder.

### ⚙️ Configure your preferences

1. Duplicate the file `config.default.sh` as `config.sh`

2. Open `config.sh` with TextEdit

3. …and change all settings to your personal preferences, using `true`/`false`.<br>(Note: if no `config.sh` is present, it will fall back to the default configs)

### 🚀 Start the scripted Setup

Maybe now is the time to go and get a coffee ☕️…

1. Open the «Terminal.app» from Applications » Utilities

2. Paste the following command to the Terminal.app, and start the setup by pressing `Return`:

```bash
cd ~/Downloads/macOS-scripted-setup-1.0.0/ && chmod +x ./run.sh && ./run.sh
```

Watch the magic happen… and occasionally interact when instructions show up (e.g. sign-in on the Mac App Store-App).

#### ✨ That's it - happy installation! :)


## Requests for changes

### Issues and feature requests
Report an [Issue](/../../issues) or start a [new Discussion](/../../discussions) for feedback or help.

### Contributions
Feel free to [fork this project](/../../fork) and add Pull Requests for any suggested changes or additions!



## Advanced settings

If you want to run additional bash commands as part of the setup, you can duplicate the template-file `mycommands.template.sh` as `mycommands.sh`, and populate it with any commands. These custom commands will be executed LAST in the whole setup (see the `run.sh` file).

### What is being done?

The script changes the following settings:

* FileVault, macOS Firewall, Mission Control, Control Centre, Finder, Dock, git, SSH Key, adds Userhome folders, Menu bar clock, Fast User Switching, and more.

…and is capable of installing these Apps:

* Xcode Command Line Tools, Homebrew, Rosetta 2, Keka, Quick Look plugins, 1Password, Safari extensions, Beyond Compare, Discord, Fig, Firefox, Google Chrome, Pixelmator Pro, Spotify, Strongbox, Telegram, Transmission, Tresorit, Warp, Xnapper, Git, Boop, Composer, Docker, SonarQube, Fork, GasMask, MAMP, Nova, Sequel Ace, and others.

Some Apps are downloaded from the official websites, other are added through Homebrew or its Mac App Store CLI extension.

---

## Inspiration and Kudos

A **BIG «THANK YOU»** to these inspiring and helfpful sources! 🫶 Make sure to check them out and leave a kudos.

* Yann Bertrand's awesome work with «[macOS-defaults](https://github.com/yannbertrand/macos-defaults)»
* Patrick Force's approach with «[macOSa](https://github.com/rockholla/macosa)» (which was a bit too complex for my use case…)
* Ryan Pavlick's helpful «[add_to_dock](https://github.com/ryanpavlick/add_to_dock)» bash scripts
* Mathias Bynens's epic «[dotfiles](https://github.com/mathiasbynens/dotfiles)» (particularly its [.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos))!
* Big KUDOS to «[Homebrew](https://github.com/Homebrew/install)» and the «[Mac App Store command line interface](https://github.com/mas-cli/mas)»! 👏
* MacRumors «[Dock to Show Running Apps Only](https://www.macrumors.com/how-to/macos-dock-show-active-apps/)», Ask Different «[identify if Filevault is enabled](https://apple.stackexchange.com/q/70969/86244)» and «[Check if OS X user is Administrator](https://apple.stackexchange.com/a/179531/86244)»
