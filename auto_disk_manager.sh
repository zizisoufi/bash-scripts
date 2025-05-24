#!/bin/bash

# Old disks list file
OLD_LIST="/tmp/old_disks.txt"
# Base directory for mounting
MOUNT_BASE="/mnt"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

# Get current disk list (only sdX devices)
CURRENT=$(lsblk -d -o NAME | grep -E '^sd[a-z]+$' | sort)

# Create initial file if this is first run
[[ ! -f "$OLD_LIST" ]] && echo "$CURRENT" > "$OLD_LIST"

# Compare to find new disks
NEW=$(comm -13 "$OLD_LIST" <(echo "$CURRENT"))

# Exit if no new disks found
[[ -z "$NEW" ]] && exit 0

# Process new disks
for disk in $NEW; do
    DEV="/dev/$disk"
    echo "📦 New disk detected: $DEV"

    # Only process if disk has no partitions
    if ! lsblk "$DEV" | grep -q part; then
        echo "🛠 Creating GPT partition table and partition on $DEV"
        parted -s "$DEV" mklabel gpt
        parted -s "$DEV" mkpart primary ext4 1MiB 100%
        sleep 2
        partprobe "$DEV"

        PART="${DEV}1"
        echo "📝 Formatting $PART as ext4"
        mkfs.ext4 -F "$PART"

        # Create mount directory with timestamp
        TIME=$(date +%Y%m%d_%H%M%S)
        DIR="$MOUNT_BASE/disk_$TIME"
        mkdir -p "$DIR"

        echo "🔗 Mounting $PART at $DIR"
        mount "$PART" "$DIR"
        
        # Add to fstab for persistent mounting
        echo "Adding to /etc/fstab for automatic mounting"
        echo "$PART $DIR ext4 defaults 0 2" >> /etc/fstab
    else
        echo "⚠ Disk $DEV already has partitions, skipping"
    fi
done

# Update disk list for next run
echo "$CURRENT" > "$OLD_LIST"

echo "✅ Disk processing complete"
exit 0