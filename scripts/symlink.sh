#!/bin/bash
echo "Creating symlinks for application configuration..."
# Create symlinks for application configuration
ln -sf ~/repos/dotfiles/config/.gitconfig ~/.gitconfig
ln -sf ~/repos/dotfiles/config/.zshrc ~/.zshrc
ln -sf ~/repos/dotfiles/config/ghostty ~/.config/ghostty/config
ln -sf ~/repos/dotfiles/config/starship.toml ~/.config/starship.toml

echo "Symlinks created successfully!"