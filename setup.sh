#!/bin/bash
echo "Starting setup script..."

# Configuration
DOTFILES_REPO="https://github.com/DrTuup/dotfiles.git"
DOTFILES_DIR="${HOME}/repos/dotfiles"

echo "Starting with Homebrew setup..."
# Check if brew is installed, if not install it
echo "Checking if brew is installed!"
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew because it is not installed!"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed successfully!"
else
  echo "Homebrew is installed."
fi

echo "Continue with Git setup..."
# Check if git is installed, if not, install it
echo "Checking if git is installed!"
if ! command -v git &>/dev/null; then
  echo "Installing git because it is not installed!"
  brew install git
  echo "git installed successfully!"
else
  echo "Git is installed."
fi

echo "Cloning the dotfiles repository..."
# Clone the repository
echo "Cloning the repository to: $DOTFILES_DIR"
git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
echo "Repository cloned successfully!"

echo "Running setup scripts from cloned repository..."
# Setup MacOS preferences
source "$DOTFILES_DIR/scripts/macos.sh"
# Install applications from Brewfile
source "$DOTFILES_DIR/scripts/applications.sh"
# Create symlinks for application configuration
source "$DOTFILES_DIR/scripts/symlinks.sh"

echo "Setup script completed!"