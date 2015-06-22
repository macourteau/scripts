#!/bin/bash -eu

# Based on http://mths.be/osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until we're finished
while true
do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

################################################################################
# General                                                                      #
################################################################################

computer_name=$(scutil --get ComputerName)
read -p "Computer name (leave empty to keep \"${computer_name}\"): " \
    computer_name

if [[ "x${computer_name}" != "x" ]]; then
  echo -n "Setting computer name to \"${computer_name}\"... "
  # Set computer name (as done via System Preferences → Sharing)
  sudo scutil --set ComputerName "${computer_name}"
  sudo scutil --set HostName "${computer_name}"
  sudo scutil --set LocalHostName "${computer_name}"
  sudo defaults write \
      /Library/Preferences/SystemConfiguration/com.apple.smb.server \
      NetBIOSName -string "${computer_name}"
  echo "done."
fi

################################################################################
# General UI/UX                                                                #
################################################################################

# Increase window resize speed for Cocoa applications
defaults write -g NSWindowResizeTime -float 0.02

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

# Key repeat rate and delay before repeat.
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 2

# Automatically quit printer app once the print jobs complete
#defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the "Are you sure you want to open this application?" dialog
#defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic termination of inactive apps
#defaults write -g NSDisableAutomaticTermination -bool true

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
#defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow \
    AdminHostInfo HostName

# Disable smart quotes as they're annoying when typing code
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                  #
################################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking \
    -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Disable "natural" (Lion-style) scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
#defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" \
#    -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewPanningMode -int 0
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess closeViewSmoothImages -bool false
# Follow the keyboard focus while zoomed in
#defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Set language and text formats
# Note: if you're in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write -g AppleLanguages -array "en" "fr"
defaults write -g AppleLocale -string "en_CA@currency=CAD"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true

# 24-hour clock
defaults write -g AppleICUForce24HourTime -bool true

# Set the timezone; see `systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "America/Montreal" > /dev/null

################################################################################
# Screen                                                                       #
################################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
#defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
#defaults write com.apple.screencapture type -string "png"

# Enable subpixel font rendering on non-Apple LCDs
defaults write -g AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
# sudo defaults write /Library/Preferences/com.apple.windowserver \
#     DisplayResolutionEnabled -bool true

################################################################################
# Finder                                                                       #
################################################################################

# Set home directory as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
# For Desktop, use `PfDe` and `file://${HOME}/Desktop/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Finder: show side bar
defaults write com.apple.finder ShowSidebar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
#defaults write com.apple.frameworks.diskimages skip-verify -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable recent items.
#/usr/libexec/PlistBuddy -c \
#    "Set :RecentApplications:MaxAmount integer 0" \
#    ~/Library/Preferences/com.apple.recentitems.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :RecentDocuments:MaxAmount integer 0" \
#    ~/Library/Preferences/com.apple.recentitems.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :RecentServers:MaxAmount integer 0" \
#    ~/Library/Preferences/com.apple.recentitems.plist

# Calculate all sizes.
/usr/libexec/PlistBuddy -c \
    "Set :StandardViewSettings:ExtendedListViewSettings:calculateAllSizes bool true" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c \
    "Set :StandardViewSettings:ListViewSettings:calculateAllSizes bool true" \
    ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c \
    "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" \
    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" \
#    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" \
#    ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c \
    "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" \
    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" \
#    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" \
#    ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c \
    "Set :DesktopViewSettings:IconViewSettings:iconSize 80" \
    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" \
#    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :StandardViewSettings:IconViewSettings:iconSize 80" \
#    ~/Library/Preferences/com.apple.finder.plist

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c \
    "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" \
    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" \
#    ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c \
#    "Set :StandardViewSettings:IconViewSettings:showItemInfo true" \
#    ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
#sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# "General", "Open with", and "Sharing & Permissions"
# defaults write com.apple.finder FXInfoPanesExpanded -dict \
#   General -bool true \
#   OpenWith -bool true \
#   Privileges -bool true

################################################################################
# Dock, Dashboard, and hot corners                                             #
################################################################################

# Set the icon size of Dock items to 50 pixels, and magnified size to 57
defaults write com.apple.dock tilesize -int 50
defaults write com.apple.dock largesize -int 57
defaults write com.apple.dock magnification -int 1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top right screen corner -> Start screen saver
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom right screen corner -> Put display to sleep
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0
# Bottom left screen corner -> Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

################################################################################
# Safari & WebKit                                                              #
################################################################################

# Set Safari's home page to Google
defaults write com.apple.Safari HomePage -string "https://www.google.ca/"

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari \
    com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled \
    -bool true

# Hide Safari's bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari's sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari's thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari's debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey \
    -bool true
defaults write com.apple.Safari \
    com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled \
    -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write -g WebKitDeveloperExtras -bool true

################################################################################
# Mail                                                                         #
################################################################################

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of
# `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut Cmd + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents \
    -dict-add "Send" -string "@\\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DraftsViewerAttributes \
    -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes \
    -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes \
    -dict-add "SortOrder" -string "received-date"

################################################################################
# Activity Monitor                                                             #
################################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
# defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

################################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                    #
################################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

defaults write com.apple.TextEdit CorrectSpellingAutomatically -bool false
defaults write com.apple.TextEdit NSDocumentSuppressTempVersionStoreWarning \
    -bool true
defaults write com.apple.TextEdit NSFixedPitchFont -string "Hermit-medium"
defaults write com.apple.TextEdit NSFixedPitchFontSize -int 12
defaults write com.apple.TextEdit PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.TextEdit ShowRuler -bool false
defaults write com.apple.TextEdit SmartQuotes -bool false
defaults write com.apple.TextEdit SmartDashes -bool false

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

################################################################################
# Mac App Store                                                                #
################################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

################################################################################
# Login                                                                        #
################################################################################

sudo /usr/libexec/PlistBuddy -c \
    "Set :GuestEnabled false" \
    /Library/Preferences/com.apple.loginwindow.plist

#sudo /usr/libexec/PlistBuddy -c \
#    "Set :SHOWFULLNAME true" \
#    /Library/Preferences/com.apple.loginwindow.plist

################################################################################
# SSH & screen sharing                                                         #
################################################################################

#sudo /usr/libexec/PlistBuddy -c \
#    "Set :com.apple.screensharing:Disabled false" \
#    /var/db/launchd.db/com.apple.launchd/overrides.plist

#sudo /usr/libexec/PlistBuddy -c \
#    "Set :com.openssh.sshd:Disabled false" \
#    /var/db/launchd.db/com.apple.launchd/overrides.plist

#sudo /usr/libexec/PlistBuddy -c \
#    "Set :com.apple.smbd:Disabled false" \
#    /var/db/launchd.db/com.apple.launchd/overrides.plist

#sudo /usr/libexec/PlistBuddy -c \
#    "Set :com.apple.AppleFileServer:Disabled false" \
#    /var/db/launchd.db/com.apple.launchd/overrides.plist

################################################################################
# Kill affected applications                                                   #
################################################################################

# for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#     "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" "Terminal" \
#     "iCal"; do
#   killall "${app}" > /dev/null 2>&1 || true
# done

echo "Done. Some of these changes require a logout/restart to take effect."
