#!/bin/bash

# 📦 Auto Disk Formatter & Mounter - Runs every 6 hours
# Author: zizi.n 🦋

SCRIPT_PATH="$(readlink -f "$0")"
CRON_JOB="0 */6 * * * $SCRIPT_PATH"

# Add cron job if not exists
crontab -l 2>/dev/null | grep -qF "$CRON_JOB" || \
  (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

LOG="$HOME/.autodisk/added_disks.log"
mkdir -p /mnt/autodisks
mkdir -p "$(dirname "$LOG")"
touch "$LOG"

for DISK in $(lsblk -d -n -o NAME | grep -vE '^loop|^ram|^sda'); do
  if ! grep -q "$DISK" "$LOG"; then

    echo "📦 New disk detected: $DISK"

    # Optional safety check:
    if lsblk /dev/$DISK | grep -q part; then
      echo "⚠️ $DISK already has partitions, skipping..."
      continue
    fi

    parted -s /dev/$DISK mklabel gpt
    parted -s /dev/$DISK mkpart primary ext4 0% 100%
    sleep 2

    PART="/dev/${DISK}1"
    for i in {1..5}; do
      [ -b "$PART" ] && break
      sleep 1
    done
    [ ! -b "$PART" ] && echo "❌ Partition $PART not found, skipping..." && continue

    mkfs.ext4 -F "$PART"
    mkdir -p /mnt/autodisks/$DISK
    mount "$PART" /mnt/autodisks/$DISK
    mountpoint -q /mnt/autodisks/$DISK && echo "✅ Mounted on /mnt/autodisks/$DISK"

    echo "$DISK" >> "$LOG"
  fi
done
