#!/bin/bash

set -ouex pipefail

log() {
  echo "=== $* ==="
}

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images

PACKAGES=(
  gnome-tweaks
  incus
  kitty
  pacrunner
  shorewall
  solaar
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
# Install from COPRs
dnf5 install -y joplin
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable taw/joplin

#### Example for enabling a System Unit File

#systemctl enable podman.socket
