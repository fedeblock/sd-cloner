#!/bin/bash

# Script to clone SD card on macOS with progress visualization

# Function to get disk size in bytes
function get_disk_size_bytes() {
    local DISK=$1
    local SIZE_LINE=$(diskutil info $DISK | grep "Disk Size:")
    local SIZE=$(echo $SIZE_LINE | awk '{print $3}')
    local UNIT=$(echo $SIZE_LINE | awk '{print $4}' | tr -d '()')
    case $UNIT in
        Bytes)
            echo $SIZE
            ;;
        KB)
            echo $(echo "$SIZE * 1000" | bc)
            ;;
        MB)
            echo $(echo "$SIZE * 1000000" | bc)
            ;;
        GB)
            echo $(echo "$SIZE * 1000000000" | bc)
            ;;
        TB)
            echo $(echo "$SIZE * 1000000000000" | bc)
            ;;
        *)
            echo "Unknown unit $UNIT"
            exit 1
            ;;
    esac
}

# Function to select the SD card
function select_sd_card() {
    echo "Available disks:"
    diskutil list
    echo ""
    read -p "Enter the disk identifier of the SD card (e.g., disk2): " SELECTED_DISK
    if [ -z "$SELECTED_DISK" ]; then
        echo "No disk selected. Exiting."
        exit 1
    fi
    # Confirm the disk
    diskutil info /dev/$SELECTED_DISK
    read -p "Is this the correct SD card? [y/N]: " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "Disk not confirmed. Exiting."
        exit 1
    fi
}

# Function to create the SD card dump
function create_dump() {
    DUMP_FILE="sdcard_dump_$(date +%Y%m%d%H%M%S).img"
    echo "Creating dump of /dev/$SOURCE_DISK into $DUMP_FILE..."
    # Unmount the disk
    diskutil unmountDisk /dev/$SOURCE_DISK
    # Create image with dd
    echo "This may take a while..."
    sudo dd if=/dev/r$SOURCE_DISK of=$DUMP_FILE bs=1m status=progress
    local EXIT_STATUS=$?
    if [ $EXIT_STATUS -ne 0 ]; then
        echo "dd command failed with exit status $EXIT_STATUS"
        exit 1
    fi
    # Optionally mount the disk again
    diskutil mountDisk /dev/$SOURCE_DISK
    echo "Dump successfully created: $DUMP_FILE"
}

# Function to burn the dump to a new SD card
function burn_dump() {
    echo "Please remove the original SD card and insert the new SD card."
    read -p "Press Enter when ready..."
    echo "Available disks:"
    diskutil list
    read -p "Enter the disk identifier of the new SD card (e.g., disk2): " DEST_DISK
    if [ -z "$DEST_DISK" ]; then
        echo "No disk selected. Exiting."
        exit 1
    fi
    # Confirm the disk
    diskutil info /dev/$DEST_DISK
    read -p "Is this the correct SD card to write to? [y/N]: " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "Disk not confirmed. Exiting."
        exit 1
    fi
    # Verify that the new SD card has enough capacity
    SOURCE_SIZE_BYTES=$(stat -f%z "$DUMP_FILE")
    DEST_SIZE_BYTES=$(get_disk_size_bytes /dev/$DEST_DISK)
    echo "Source image size: $SOURCE_SIZE_BYTES bytes"
    echo "Destination SD card size: $DEST_SIZE_BYTES bytes"
    if [ $DEST_SIZE_BYTES -lt $SOURCE_SIZE_BYTES ]; then
        echo "The destination SD card is smaller than the source image. Cannot proceed."
        exit 1
    fi
    # Unmount the destination disk
    diskutil unmountDisk /dev/$DEST_DISK
    # Write the image with dd
    echo "Writing dump to /dev/$DEST_DISK..."
    echo "This may take a while..."
    sudo dd if=$DUMP_FILE of=/dev/r$DEST_DISK bs=1m status=progress
    local EXIT_STATUS=$?
    if [ $EXIT_STATUS -ne 0 ]; then
        echo "dd command failed with exit status $EXIT_STATUS"
        exit 1
    fi
    # Eject the disk
    diskutil eject /dev/$DEST_DISK
    echo "Dump successfully burned to /dev/$DEST_DISK."
}

# Main script logic

echo "What would you like to do?"
echo "1) Create SD card dump"
echo "2) Burn dump to SD card"
echo "3) Clone SD card (dump and burn)"
read -p "Select an option [1/2/3]: " OPTION

case $OPTION in
    1)
        select_sd_card
        SOURCE_DISK=$SELECTED_DISK
        create_dump
        ;;
    2)
        read -p "Enter the dump file to burn: " DUMP_FILE
        if [ ! -f "$DUMP_FILE" ]; then
            echo "Dump file not found. Exiting."
            exit 1
        fi
        burn_dump
        ;;
    3)
        select_sd_card
        SOURCE_DISK=$SELECTED_DISK
        create_dump
        burn_dump
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
