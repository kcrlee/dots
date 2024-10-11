#!/bin/bash

#TODO:

# add os detection
# add nvidia detection
# add nvidia driver install

# check if the script is run as root
if [ "$EUID" -ne 0 ]; then
	echo "This script needs to be run as root. Re-run with 'sudo'."
fi

check_and_install() {
	package=$1
	if ! dnf list installed "$package" >/dev/null 2>&1; then
		sudo dnf install -y "$package"
	fi
}

# Utils
check_and_install wget
check_and_install curl
check_and_install flatpak

# Install and configure ZSH
sudo dnf install zsh -y
which zsh
chsh -s /bin/zsh
zsh

# Install Oh-my-zsh! -> https://ohmyz.sh/
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Activate the plugins of Zsh
echo "plugins=(
  # other plugins...
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)" >>~/.zshrc

# Fonts
git clone https://github.com/ryanoasis/nerd-fonts.git
sudo ./nerd-fonts/install.sh

# Add free and non-free RPM packages
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
