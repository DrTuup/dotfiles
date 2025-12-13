#!/bin/bash
echo "Creating symlinks for application configuration..."

# Create directories if they don't exist for config files which do not live in home directory
mkdir -p ~/.config/ghostty

# Create symlinks for application configuration
ln -sf ~/repos/dotfiles/config/.gitconfig ~/.gitconfig
ln -sf ~/repos/dotfiles/config/.zshrc ~/.zshrc
ln -sf ~/repos/dotfiles/config/ghostty ~/.config/ghostty/config
ln -sf ~/repos/dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/repos/dotfiles/Brewfile ~/Brewfile

echo "Symlinks created successfully!"