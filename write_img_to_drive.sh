#!/bin/bash

write_image_to_drive() {
    # Check if the script is run as root
    if [ "$(id -u)" != "0" ]; then
        echo "User is not root"
        exit 1
    fi

    IMAGE="$1"
    DRIVE="$2"

    if [ -z "$IMAGE" ]; then
        echo "No image file specified"
        exit 1
    fi

    if [ -z "$DRIVE" ]; then
        echo "No drive specified"
        exit 1
    fi

    if [ ! -f "$IMAGE" ]; then
        echo "Image file does not exist"
        exit 1
    fi

    if grep -qs "$DRIVE" /proc/mounts; then
        echo "Unmounting $DRIVE..."
        sudo umount "$DRIVE"*
    fi

    echo "Writing $IMAGE to $DRIVE..."
    sudo dd if="$IMAGE" of="$DRIVE" bs=4M status=progress

    if [ $? -eq 0 ]; then
        echo "Done"
    else
        echo "Failed to write $IMAGE to $DRIVE"
        exit 1
    fi
}

write_image_to_drive "$1" "$2"
