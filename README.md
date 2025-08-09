# Phoenix32 Ubuntu Setup

**An automated, comprehensive Ubuntu setup script that gets you from fresh install to fully configured development environment in minutes.**

## ✨ What This Script Does

This script transforms a fresh Ubuntu installation into a secure, productive development environment by automatically installing and configuring:

### 🛡️ Security & System
- **System Updates**: Latest packages and security patches
- **UFW Firewall**: Configured with secure defaults (deny incoming, allow outgoing)
- **Fail2Ban**: Protection against brute-force attacks
- **Essential Tools**: build-essential, git, curl, wget, unzip, and more

### 💾 Backup & Recovery
- **Timeshift**: System snapshot and restore capability

### 🎨 Shell & Terminal
- **Zsh**: Modern shell with better features than bash
- **Oh My Zsh**: Beautiful themes and powerful plugins

### 📱 Applications
- **VS Code**: Popular code editor (via Snap)
- **VLC**: Media player for all formats
- **OBS Studio**: Screen recording and streaming
- **Brave Browser**: Privacy-focused web browser
- **Flatpak Support**: Access to additional applications via Flathub

### 🎮 Hardware Support
- **NVIDIA Drivers**: Automatic detection and installation for NVIDIA GPUs

## 🚀 Quick Start

### Prerequisites
- Fresh Ubuntu 20.04, 22.04, or 24.04 installation
- Internet connection
- User account with sudo privileges

### Installation

1. **Download the script:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/yourusername/phoenix32-setup/main/setup.sh -o phoenix32-setup.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x phoenix32-setup.sh
   ```

3. **Run the script:**
   ```bash
   ./phoenix32-setup.sh
   ```

4. **Follow the prompts** and let the script work its magic!

5. **Reboot when complete:**
   ```bash
   sudo reboot
   ```

## 🔧 Post-Installation Steps

After running the script and rebooting:

1. **Set Zsh as your default shell:**
   ```bash
   chsh -s $(which zsh)
   ```

2. **Configure Timeshift backups:**
   - Open Timeshift from the applications menu
   - Set up automated snapshots (recommended: daily snapshots, keep 5)

3. **Customize your shell:**
   - Edit `~/.zshrc` to change themes and add plugins
   - Popular theme: `ZSH_THEME="powerlevel10k/powerlevel10k"`

4. **Configure your firewall** (if needed):
   ```bash
   # Allow specific applications
   sudo ufw allow [port-number]
   
   # Check status
   sudo ufw status
   ```

## 📦 What Gets Installed

### System Packages
```
build-essential, git, curl, wget, unzip, snapd, flatpak,
gnome-software-plugin-flatpak, apt-transport-https,
ca-certificates, software-properties-common, ufw, fail2ban,
timeshift, zsh
```

### Snap Applications
```
code (VS Code), vlc, obs-studio, brave
```

### Repositories Added
- **Flathub**: For additional Flatpak applications

## 🛡️ Security Features

The script implements several security best practices:

- **Firewall Configuration**: UFW with restrictive defaults
- **Intrusion Prevention**: Fail2Ban monitors and blocks suspicious activity
- **System Updates**: Ensures latest security patches
- **SSH Protection**: Firewall allows SSH while Fail2Ban protects against brute force

## 🔍 Troubleshooting

### Common Issues

**Script fails with permission errors:**
```bash
# Ensure your user is in the sudo group
sudo usermod -aG sudo $USER
# Log out and back in
```

**Snap applications don't appear:**
```bash
# Restart snapd service
sudo systemctl restart snapd
# Wait a few minutes for apps to appear
```

**Oh My Zsh doesn't activate:**
```bash
# Manually change shell
chsh -s $(which zsh)
# Log out and back in
```

**NVIDIA drivers not working:**
```bash
# Check if drivers are loaded
nvidia-smi
# If not working, try manual installation
sudo ubuntu-drivers devices
sudo apt install nvidia-driver-XXX  # Replace XXX with recommended version
```

### Getting Help

If you encounter issues:

1. **Check the script output** for specific error messages
2. **Run individual commands** manually to isolate problems
3. **Check system logs**: `journalctl -xe`
4. **Verify internet connection** for download failures

## 🎛️ Customization

### Modifying the Script

The script is modular and easy to customize:

- **Add applications**: Extend the `install_snap_apps()` function
- **Change security settings**: Modify the `setup_firewall()` function
- **Add repositories**: Include additional sources in the appropriate section

### Configuration Files

After installation, customize these files:
- **Zsh**: `~/.zshrc`
- **Git**: `~/.gitconfig`
- **VS Code**: Settings accessible through the editor

## 🔄 Updates and Maintenance

### Keeping Your System Updated
```bash
# Regular system updates
sudo apt update && sudo apt upgrade

# Update snap packages
sudo snap refresh

# Update flatpak applications
flatpak update
```

### Script Updates
Check the repository periodically for script improvements and new features.

## ⚡ Performance Notes

- **Initial run time**: 10-20 minutes depending on internet speed
- **Disk space**: ~2-3GB additional space used
- **Memory usage**: Standard Ubuntu requirements apply
- **CPU impact**: Minimal after installation complete

## 🤝 Contributing

Found a bug or want to add a feature?

1. Fork the repository
2. Create a feature branch
3. Test your changes on a fresh Ubuntu install
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Oh My Zsh** community for the amazing shell framework
- **Ubuntu** team for the excellent base system
- **Snap** and **Flatpak** teams for modern package management
- All the open-source projects that make this setup possible

---

**🔥 Ready to phoenix your Ubuntu setup? Let's get you loaded! 🔥**
