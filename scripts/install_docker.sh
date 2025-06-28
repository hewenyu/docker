#!/bin/bash

# ==============================================================================
# Docker & User Setup Script for Debian
#
# Description:
# This script automates the setup process on a Debian-based VPS. It performs:
# 1. System update and installation of essential packages.
# 2. Timezone configuration to Asia/Shanghai.
# 3. Installation of Docker and Docker Compose.
# 4. Creation of a standard user 'yueban' with sudo access to Docker.
# 5. Setup for key-based SSH authentication for the new user.
#
# Usage:
# Run this script as root:
# sudo bash ./install_docker.sh
#
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Check for root privileges ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root. Please use 'sudo'." >&2
  exit 1
fi

# --- Stage 1: System Update and Basic Tools Installation ---
echo "[INFO] Updating package list and installing essential packages..."
apt-get update
apt-get install -y vim curl wget htop git ca-certificates gnupg

# --- Stage 2: Timezone Configuration ---
echo "[INFO] Setting timezone to Asia/Shanghai..."
timedatectl set-timezone Asia/Shanghai

# --- Stage 3: Docker Installation ---
echo "[INFO] Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- Stage 4: User Creation and Configuration ---
USERNAME="yueban"
echo "[INFO] Creating user '$USERNAME'..."

if id -u "$USERNAME" &>/dev/null; then
    echo "[INFO] User '$USERNAME' already exists. Skipping creation."
else
    useradd -m -s /bin/bash "$USERNAME"
    echo "[INFO] User '$USERNAME' created successfully."
fi

echo "[INFO] Adding user '$USERNAME' to the 'docker' group..."
usermod -aG docker "$USERNAME"

# --- Stage 5: SSH Key Authentication Setup ---
echo "[INFO] Setting up SSH directory for '$USERNAME'..."
SSH_DIR="/home/$USERNAME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
touch "$AUTH_KEYS_FILE"

# Set correct permissions
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS_FILE"
chown -R "$USERNAME":"$USERNAME" "$SSH_DIR"

# --- Final Instructions ---
echo "================================================================================"
echo "[SUCCESS] Script finished."
echo
echo "IMPORTANT ACTION REQUIRED:"
echo "To enable SSH login for the '$USERNAME' user, you must manually add your"
echo "public SSH key to the following file:"
echo "  $AUTH_KEYS_FILE"
echo
echo "You can do this by running a command like this on your local machine:"
echo "  ssh-copy-id $USERNAME@<your_vps_ip>"
echo
echo "Or by manually pasting your public key into the file on the server."
echo "================================================================================"

exit 0 