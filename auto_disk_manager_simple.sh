#!/bin/bash

# 📦 ساده‌ترین نسخه‌ی اتو فرمت و مانت دیسک‌های جدید

LOG="$HOME/.autodisk/added_disks.log"
mkdir -p /mnt/autodisks
mkdir -p "$(dirname "$LOG")"
touch "$LOG"

for DISK in $(lsblk -d -n -o NAME | grep -vE '^loop|^ram|^sda'); do
  if ! grep -q "$DISK" "$LOG"; then

    echo "🆕 دیسک جدید پیدا شد: $DISK"

    # ساخت پارتیشن GPT و ساخت پارتیشن ext4
    parted -s /dev/$DISK mklabel gpt
    parted -s /dev/$DISK mkpart primary ext4 0% 100%
    sleep 2

    PART="/dev/${DISK}1"
    sleep 3  # برای اطمینان از ساخته شدن پارتیشن

    # فرمت پارتیشن و مانت
    mkfs.ext4 -F "$PART"
    mkdir -p /mnt/autodisks/$DISK
    mount "$PART" /mnt/autodisks/$DISK

    echo "$DISK" >> "$LOG"
    echo "✅ دیسک $DISK مانت شد روی /mnt/autodisks/$DISK"
  fi
done
