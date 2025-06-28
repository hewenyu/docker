#!/bin/bash

# ==============================================================================
# UFW Firewall Setup Script for Debian
#
# Description:
# This script automates the configuration of UFW (Uncomplicated Firewall).
# It sets up the following rules:
# 1. Denies all incoming traffic by default.
# 2. Allows all outgoing traffic.
# 3. Allows SSH (22/tcp), HTTP (80/tcp), and HTTPS (443/tcp).
# 4. Denies ICMP (ping) requests.
#
# Usage:
# Run this script as root:
# sudo bash ./setup_firewall.sh
#
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Check for root privileges ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root. Please use 'sudo'." >&2
  exit 1
fi

# --- Stage 1: Install UFW ---
echo "[INFO] Installing UFW (Uncomplicated Firewall)..."
apt-get update
apt-get install -y ufw

# --- Stage 2: Configure Firewall Rules ---
echo "[INFO] Configuring UFW rules..."

# Reset to defaults to ensure a clean state
ufw reset >/dev/null

# Set default policies
ufw default deny incoming
ufw default allow outgoing

# Allow essential ports
ufw allow ssh     # Equivalent to 22/tcp
ufw allow http    # Equivalent to 80/tcp
ufw allow https   # Equivalent to 443/tcp

# --- Stage 3: Deny Ping (ICMP) ---
BEFORE_RULES_FILE="/etc/ufw/before.rules"
PING_RULE="-A ufw-before-input -p icmp --icmp-type echo-request -j DROP"

echo "[INFO] Configuring rules to deny ping requests..."
if grep -qF -- "$PING_RULE" "$BEFORE_RULES_FILE"; then
  echo "[INFO] Ping deny rule already exists. Skipping."
else
  # Insert the rule before the final COMMIT line
  sed -i -e "/^# End of file/i \n# Block incoming PING requests (ICMP echo-request)\n$PING_RULE\n" "$BEFORE_RULES_FILE"
  echo "[INFO] Ping deny rule added."
fi

# --- Stage 4: Enable Firewall ---
echo "[INFO] Enabling UFW..."
# Use --force to avoid interactive prompt, as this is a script
ufw --force enable

# --- Final Status ---
echo "[SUCCESS] Firewall is now active."
echo "[INFO] Displaying firewall status:"
ufw status verbose

exit 0 