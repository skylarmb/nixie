#!/usr/bin/env bash
#
# Bootstrap script for nixie dotfiles
# This script sets up a new machine with home-manager and dotfiles configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

info "Starting nixie dotfiles installation..."
echo

# Step 1: Check for Nix installation
info "Checking for Nix installation..."
if ! command -v nix &> /dev/null; then
    error "Nix is not installed. Please install Nix first:"
    echo "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    echo "  or visit: https://nixos.org/download.html"
fi
success "Nix is installed"
echo

# Step 2: Ensure flakes are enabled
info "Checking Nix configuration..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features.*flakes" ~/.config/nix/nix.conf 2>/dev/null; then
    warn "Enabling Nix flakes and nix-command..."
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi
success "Nix flakes enabled"
echo

# Step 3: Detect platform
info "Detecting platform..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="darwin"
    SYSTEM_ARCH=$(uname -m)
    if [[ "$SYSTEM_ARCH" == "arm64" ]]; then
        success "Detected macOS (Apple Silicon)"
    else
        success "Detected macOS (Intel)"
    fi
else
    PLATFORM="linux"
    success "Detected Linux"
fi
echo

# Step 4: Setup private configuration directory
info "Setting up private configuration..."
if [ ! -d "$HOME/.private" ]; then
    mkdir -p "$HOME/.private"

    # Copy templates
    if [ -f ".private.template/.zshrc" ]; then
        cp ".private.template/.zshrc" "$HOME/.private/.zshrc"
        success "Created ~/.private/.zshrc from template"
    fi

    if [ -f ".private.template/.gitconfig" ]; then
        cp ".private.template/.gitconfig" "$HOME/.private/.gitconfig"
        success "Created ~/.private/.gitconfig from template"
    fi

    warn "IMPORTANT: Edit the files in ~/.private/ to customize your configuration"
    warn "  - ~/.private/.zshrc: Set WORKSPACE, GITHUB_TOKEN, etc."
    warn "  - ~/.private/.gitconfig: Set your git user info"
    echo
else
    info "~/.private/ directory already exists, skipping template copy"
    echo
fi

# Step 5: Verify flake.nix
info "Checking flake configuration..."
if [ -f "flake.nix" ]; then
    success "flake.nix found"
    echo
else
    error "flake.nix not found! This file is required for installation."
fi

# Step 6: Update flake lock
info "Updating flake dependencies..."
if nix flake update; then
    success "Flake dependencies updated"
else
    warn "Failed to update flake (continuing anyway)"
fi
echo

# Step 7: Build and activate home-manager configuration
info "Building home-manager configuration..."
USERNAME=$(whoami)

if [ "$PLATFORM" == "darwin" ]; then
    FLAKE_CONFIG="${USERNAME}@darwin"
else
    FLAKE_CONFIG="${USERNAME}@linux"
fi

info "Using configuration: $FLAKE_CONFIG"
echo

# Check if home-manager is available
if command -v home-manager &> /dev/null; then
    info "home-manager found, using it directly..."
    if home-manager switch --flake ".#$FLAKE_CONFIG"; then
        success "home-manager configuration activated!"
    else
        error "Failed to activate home-manager configuration"
    fi
else
    info "home-manager not found, building with nix..."
    if nix run home-manager/master -- switch --flake ".#$FLAKE_CONFIG"; then
        success "home-manager configuration activated!"
    else
        error "Failed to activate home-manager configuration"
    fi
fi

echo
success "============================================"
success "Installation complete!"
success "============================================"
echo
info "Next steps:"
echo "  1. Edit ~/.private/.zshrc and ~/.private/.gitconfig with your personal settings"
echo "  2. Close and reopen your terminal (or run: exec zsh)"
echo "  3. Start tmux - plugins will be installed automatically"
echo "  4. Open nvim - Lazy.nvim will install plugins automatically"
echo
info "To update your configuration in the future:"
echo "  cd $SCRIPT_DIR && home-manager switch --flake '.#$FLAKE_CONFIG'"
echo
info "To update dependencies:"
echo "  cd $SCRIPT_DIR && nix flake update && home-manager switch --flake '.#$FLAKE_CONFIG'"
echo
