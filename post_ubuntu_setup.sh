#!/bin/bash

# Phoenix32 Ubuntu Setup Script
# Enhanced version with error handling and user interaction
# Compatible with Ubuntu 20.04, 22.04, and 24.04

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${PURPLE}🔥 Phoenix32 Ubuntu Setup — Let's get you loaded! 🔥${NC}"
    echo -e "${BLUE}================================================${NC}"
}

print_step() {
    echo -e "\n${YELLOW}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
    exit 1
}

print_warning() {
    echo -e "${YELLOW}⚠️  Warning: $1${NC}"
}

check_ubuntu_version() {
    if ! grep -q "Ubuntu" /etc/os-release; then
        print_error "This script is designed for Ubuntu. Detected: $(lsb_release -d | cut -f2)"
    fi
    
    VERSION=$(lsb_release -rs)
    if [[ "$VERSION" < "20.04" ]]; then
        print_error "Ubuntu 20.04 or newer required. Detected: $VERSION"
    fi
    
    print_success "Ubuntu $VERSION detected - compatible!"
}

check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        echo "This script requires sudo privileges. Please enter your password:"
        sudo -v || print_error "Failed to obtain sudo privileges"
    fi
    print_success "Sudo privileges confirmed"
}

prompt_user() {
    echo -e "\n${BLUE}This script will install and configure:${NC}"
    echo "• System updates and essential tools"
    echo "• Security tools (UFW firewall, Fail2Ban)"
    echo "• Backup solution (Timeshift)"
    echo "• Development tools (build-essential, git, curl)"
    echo "• Zsh with Oh My Zsh"
    echo "• Applications (VS Code, VLC, OBS Studio, Brave Browser)"
    echo "• Flatpak support with Flathub"
    echo "• NVIDIA drivers (if GPU detected)"
    
    echo -e "\n${YELLOW}Do you want to continue? (y/N):${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled by user"
        exit 0
    fi
}

update_system() {
    print_step "Updating system packages"
    sudo apt update || print_error "Failed to update package lists"
    sudo apt upgrade -y || print_error "Failed to upgrade packages"
    print_success "System updated successfully"
}

install_essentials() {
    print_step "Installing essential development tools"
    sudo apt install -y \
        build-essential \
        git \
        curl \
        wget \
        unzip \
        snapd \
        flatpak \
        gnome-software-plugin-flatpak \
        apt-transport-https \
        ca-certificates \
        software-properties-common || print_error "Failed to install essential tools"
    print_success "Essential tools installed"
}

setup_firewall() {
    print_step "Configuring UFW firewall"
    sudo apt install -y ufw || print_error "Failed to install UFW"
    
    # Set default policies
    sudo ufw --force default deny incoming
    sudo ufw --force default allow outgoing
    
    # Allow SSH (important for remote access)
    sudo ufw --force allow ssh
    
    # Enable firewall
    sudo ufw --force enable
    
    print_success "UFW firewall configured and enabled"
    sudo ufw status
}

install_security_tools() {
    print_step "Installing security tools"
    sudo apt install -y fail2ban || print_error "Failed to install Fail2Ban"
    
    # Start and enable fail2ban
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    
    print_success "Security tools installed and configured"
}

install_backup_solution() {
    print_step "Installing backup solution"
    sudo apt install -y timeshift || print_error "Failed to install Timeshift"
    print_success "Timeshift backup solution installed"
}

setup_flatpak() {
    print_step "Setting up Flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    print_success "Flatpak configured with Flathub repository"
}

install_zsh() {
    print_step "Installing and configuring Zsh"
    sudo apt install -y zsh || print_error "Failed to install Zsh"
    
    # Install Oh My Zsh (suppress the shell change during script)
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || print_warning "Oh My Zsh installation had issues"
    fi
    
    print_success "Zsh and Oh My Zsh installed"
    print_warning "Run 'chsh -s \$(which zsh)' after reboot to set Zsh as default shell"
}

install_snap_apps() {
    print_step "Installing applications via Snap"
    
    # Wait for snapd to be ready
    sudo systemctl start snapd
    sleep 5
    
    # Install apps
    sudo snap install code --classic || print_warning "Failed to install VS Code"
    sudo snap install vlc || print_warning "Failed to install VLC"
    sudo snap install obs-studio || print_warning "Failed to install OBS Studio"
    sudo snap install brave || print_warning "Failed to install Brave Browser"
    
    print_success "Snap applications installed"
}

check_nvidia() {
    print_step "Checking for NVIDIA GPU"
    if lspci | grep -i nvidia > /dev/null; then
        print_success "NVIDIA GPU detected — installing drivers"
        sudo ubuntu-drivers autoinstall || print_warning "NVIDIA driver installation had issues"
        print_warning "Reboot required for NVIDIA drivers to take effect"
        return 0
    else
        print_success "No NVIDIA GPU detected, skipping driver installation"
        return 1
    fi
}

cleanup() {
    print_step "Cleaning up"
    sudo apt autoremove -y
    sudo apt autoclean
    print_success "System cleanup completed"
}

main() {
    print_header
    
    # Pre-flight checks
    check_ubuntu_version
    check_sudo
    prompt_user
    
    # System setup
    update_system
    install_essentials
    setup_firewall
    install_security_tools
    install_backup_solution
    setup_flatpak
    
    # Applications
    install_zsh
    install_snap_apps
    
    # Hardware-specific
    NVIDIA_INSTALLED=$(check_nvidia && echo "true" || echo "false")
    
    # Cleanup
    cleanup
    
    # Final message
    echo -e "\n${PURPLE}🎉 Phoenix32 Setup Complete! 🎉${NC}"
    echo -e "${GREEN}✅ Your Ubuntu system is now configured and ready to use!${NC}"
    
    echo -e "\n${BLUE}Next steps:${NC}"
    echo "1. Reboot your system: sudo reboot"
    echo "2. Set Zsh as default shell: chsh -s \$(which zsh)"
    echo "3. Configure Timeshift for automated backups"
    echo "4. Customize your Oh My Zsh theme and plugins"
    
    if [ "$NVIDIA_INSTALLED" = "true" ]; then
        echo "5. NVIDIA drivers installed - reboot required for full functionality"
    fi
    
    echo -e "\n${YELLOW}🔥 Welcome to your enhanced Ubuntu experience! 🔥${NC}"
}

# Run main function
main "$@"
