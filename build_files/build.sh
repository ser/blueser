#!/bin/bash

set -ouex pipefail

log() {
  echo "=== $* ==="
}

### Install packages

# Add Google repo for antigravity
tee /etc/yum.repos.d/antigravity.repo << EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images

PACKAGES=(
  antigravity
  chromium
  genisoimage
  git-crypt
  gnome-tweaks
  incus
  libpq-devel
  kitty
  netcat
  pacrunner
  perl-hivex
  pssh
  shorewall
  snapd
  solaar
  virt-install
  wimlib-utils
)

REMOVALS=(
  firewalld
  starship
)

# this installs a package from fedora repos
log "Installing packages using dnf5..."
dnf5 install --setopt=install_weak_deps=False -y \
  ${PACKAGES[@]}

# this removes packages we do not like
log "Removing packages using dnf5..."
dnf5 remove -y \
  ${REMOVALS[@]}

# Use a COPR
dnf5 -y copr enable taw/joplin
dnf5 -y copr enable petersen/nix

# Install from COPRs
dnf5 install -y joplin nix

# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable taw/joplin
dnf5 -y copr disable petersen/nix
