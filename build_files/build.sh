#!/bin/bash

set -ouex pipefail

log() {
	echo "=== $* ==="
}

### Install packages

# Add Google repo for antigravity
tee /etc/yum.repos.d/antigravity.repo <<EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

# Add MS repo for edge
tee /etc/yum.repos.d/edge.repo <<EOL
[edge-rpm]
name=Edge RPM Repository
baseurl=https://packages.microsoft.com/yumrepos/edge/
enabled=1
gpgcheck=0
EOL

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images

PACKAGES=(
	antigravity
	bubblewrap
	chromium
	fd-find
	genisoimage
	git-crypt
	gnome-tweaks
	htop
	incus
	libpq-devel
	kitty
	#microsoft-edge-stable
	netcat
	nmap
	pacrunner
	perl-hivex
	pssh
	shorewall
	snapd
	solaar
	strace
	virt-install
	virt-manager
	vlc-cli
	vlc-gui-ncurses
	vlc-gui-qt
	vlc-plugins-all
	wimlib-utils
)

REMOVALS=(
	firewalld
	nano
	starship
)

# this installs a package from fedora repos
log "Installing packages using dnf5..."
dnf5 install --setopt=install_weak_deps=False -y \
	"${PACKAGES[@]}"

# this removes packages we do not like
log "Removing packages using dnf5..."
dnf5 remove -y \
	"${REMOVALS[@]}"

# Use a COPR
dnf5 -y copr enable taw/joplin
#dnf5 -y copr enable petersen/nix
dnf5 -y copr enable 0x444d/looking-glass
dnf5 -y copr enable agriffis/neovim-nightly
dnf5 -y copr enable gigirassy/zellij 

# Install from COPRs
dnf5 install --setopt=install_weak_deps=False -y \
	joplin looking-glass-client neovim python3-neovim zellij
#nix

# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable taw/joplin
#dnf5 -y copr disable petersen/nix
dnf5 -y copr disable 0x444d/looking-glass
dnf5 -y copr disable agriffis/neovim-nightly
dnf5 -y copr disable gigirassy/zellij
