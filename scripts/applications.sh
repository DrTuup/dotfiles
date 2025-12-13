#!/bin/bash
echo "Installing software according to brewfile..."
brew bundle install --file ~/repos/dotfiles/Brewfile
echo "Software installation completed!"