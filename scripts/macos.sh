#!/bin/bash
# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
echo "Setting MacOS preferences..."

osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
# Dock
defaults write com.apple.dock "autohide" -bool "false"
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "genie"
killall Dock

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "FinderSpawnTab" -bool "true"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
killall Finder

# Mouse and Trackpad
defaults write NSGlobalDomain com.apple.mouse.linear -bool "false"
defaults write NSGlobalDomain com.apple.mouse.scaling -float "2"
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "1"
defaults write com.apple.AppleMultitouchTrackpad "DragLock" -bool "false"
defaults write com.apple.AppleMultitouchTrackpad "Dragging" -bool "false"
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "false"

# Keyboard
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "true"
defaults write com.apple.HIToolbox AppleFnUsageType -int "0"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool "false"
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"