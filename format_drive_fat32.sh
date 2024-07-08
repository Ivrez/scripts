#!/bin/bash

# check existing disks
check_disks() {
    lsblk -o NAME,FSTYPE,SIZE -dn -e 7,11 | awk '{print "/dev/" $1, $2, $3}'
}

# format the specified flash drive to fat32
format_drive_fat32() {
    # Check if the script is run as root
    if [ "$(id -u)" != "0" ]; then
        echo "User is not root"
        exit 1
    fi

    FLASH_DRIVE="$1"

    if [ -z "$FLASH_DRIVE" ]; then
        echo "No flash drive specified"
        exit 1
    fi

    if grep -qs "$FLASH_DRIVE" /proc/mounts; then
        echo "Unmounting $FLASH_DRIVE..."
        sudo umount "$FLASH_DRIVE"*
    fi

    # Wipe the beginning of the drive to remove any existing file system signatures
    sudo dd if=/dev/zero of="$FLASH_DRIVE" bs=1M count=10

    # Delete all partitions
    sudo sfdisk --delete "$FLASH_DRIVE"

    # Create new partition
    sudo parted "$FLASH_DRIVE" mklabel msdos
    sudo parted "$FLASH_DRIVE" mkpart primary fat32 0% 100%

    sleep 2

    if grep -qs "$FLASH_DRIVE" /proc/mounts; then
        echo "Unmounting $FLASH_DRIVE..."
        sudo umount "$FLASH_DRIVE"*
    fi

    # Format new partition to FAT32
    sudo mkfs.vfat -F 32 -n NEWSD "${FLASH_DRIVE}1"

    # Check return code of mkfs.vfat
    if [ $? -eq 0 ]; then
        echo "Done"
    else
        echo "Failed to format $FLASH_DRIVE"
        exit 1
    fi
}
# Parse command line arguments
case "$1" in
    -c|--check)
        check_disks
        ;;
    -f|--format)
        format_drive_fat32 "$2"
        ;;
    *)
        echo "Usage: $0 [OPTION...] [FLASH_DRIVE]"
        echo "-c, --check       show existing disks via lsblk"
        echo "-f, --format      format disk to fat32"
        exit 1
        ;;
esac
