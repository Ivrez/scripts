#!/bin/bash

# check if root
if [ "$(id -u)" != "0" ]; then
    echo "user not root"
    exit 1
fi

FLASH_DRIVE="$1"

if grep -qs "$FLASH_DRIVE" /proc/mounts; then
    echo "umount $FLASH_DRIVE..."
    sudo umount $FLASH_DRIVE*
fi

# delete all partitions
sudo sfdisk --delete "$FLASH_DRIVE"

# create new partition
sudo parted $FLASH_DRIVE mklabel msdos
sudo parted $FLASH_DRIVE mkpart primary fat32 0% 100%

sleep 1

if grep -qs "$FLASH_DRIVE" /proc/mounts; then
    echo "umount $FLASH_DRIVE..."
    sudo umount $FLASH_DRIVE*
fi

# format new partition to FAT32
sudo mkfs.vfat -F 32 -n NEWSD ${FLASH_DRIVE}1

# check return code mkfs.vfat
if [ $? -eq 0 ]; then
    echo "done"
fi
