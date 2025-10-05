#!/bin/bash

set -ouex pipefail

log() {
  echo "=== $* ==="
}

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

PACKAGES=(
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

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket
