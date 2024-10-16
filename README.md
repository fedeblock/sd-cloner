# SD Card Cloning Script for macOS

This script allows you to clone an SD card on macOS by creating a disk image (dump) and writing it to another SD card. It provides options to create a dump of an SD card, burn an existing dump to an SD card, or clone an SD card directly by performing both actions sequentially. Progress is displayed during the operations.

## Features

- **Create Dump**: Create an image of the selected SD card.
- **Burn Dump**: Write an existing image to an SD card.
- **Clone SD Card**: Create a dump of an SD card and burn it to another SD card.
- **Progress Visualization**: Shows progress during dump creation and burning process.
- **Size Verification**: Checks if the destination SD card has enough capacity before writing.

## Prerequisites

- **macOS**: The script is designed to run on macOS.
- **Administrative Privileges**: Some operations require `sudo` privileges.
- **Tools Used**: The script uses built-in macOS tools like `diskutil`, `dd`, `awk`, `bc`, and `grep`.

## Installation

1. **Download the Script**: Save the script as `clone_sd.sh` in your desired directory.
2. **Make the Script Executable**: Open Terminal, navigate to the directory where you saved the script, and run:

   ```bash
   chmod +x clone_sd.sh
   ```

## Usage

Run the script from the Terminal:

```bash
./clone_sd.sh
```

Upon execution, you will be prompted to choose one of the following options:

1. **Create SD card dump**
2. **Burn dump to SD card**
3. **Clone SD card (dump and burn)**

### Option 1: Create SD Card Dump

1. **Select the SD Card**: The script will display a list of available disks. Enter the identifier of the SD card you wish to clone (e.g., `disk2`).
2. **Confirmation**: Confirm that you have selected the correct SD card.
3. **Dump Creation**: The script will unmount the SD card and create a disk image (`.img` file) with a timestamped filename.
4. **Progress Display**: The `dd` command will display progress information during the dump creation.
5. **Completion**: Once completed, the SD card will be remounted, and the dump file will be saved in the current directory.

### Option 2: Burn Dump to SD Card

1. **Provide Dump File**: Enter the path to the existing dump file you wish to burn.
2. **Insert Destination SD Card**: Remove any SD cards and insert the SD card you wish to write to.
3. **Select the SD Card**: The script will display a list of available disks. Enter the identifier of the new SD card (e.g., `disk2`).
4. **Confirmation**: Confirm that you have selected the correct SD card to write to.
5. **Size Verification**: The script will verify that the destination SD card has enough capacity to hold the dump.
6. **Burning Process**: The script will unmount the SD card and write the dump file to it.
7. **Progress Display**: The `dd` command will display progress information during the burning process.
8. **Completion**: Once completed, the SD card will be ejected.

### Option 3: Clone SD Card (Dump and Burn)

This option combines both Option 1 and Option 2:

1. **Select the Source SD Card**: Follow the steps from Option 1 to create a dump.
2. **Insert Destination SD Card**: Follow the steps from Option 2 to burn the dump to a new SD card.

## Important Notes

- **Caution**: The script uses the `dd` command, which can overwrite any disk if used incorrectly. Ensure you select the correct disk identifiers to avoid data loss.
- **Administrative Privileges**: You will be prompted for your administrator password when required.
- **Progress Visualization**: The script uses `status=progress` with `dd` to display the progress. This requires a version of `dd` that supports this option (available in recent macOS versions).
- **Alternative Progress Visualization**: If `status=progress` is not supported, you can install `pv` (Pipe Viewer) and modify the `dd` commands accordingly.
- **Compression (Optional)**: You can modify the script to compress the dump file using `gzip` or `xz` to save disk space.

## Troubleshooting

- **dd Command Not Found**: Ensure that you are running the script on macOS and have the necessary command-line tools installed.
- **Permission Denied**: Make sure you have executable permissions for the script (`chmod +x clone_sd.sh`) and run it with the necessary privileges.
- **Incorrect Disk Identifier**: Double-check the disk identifiers using `diskutil list` before confirming to prevent accidental data loss.

## Disclaimer

Use this script at your own risk. The author is not responsible for any data loss or damage caused by misuse of this script. Always ensure that you have backups of important data and double-check disk identifiers before proceeding.

## License

This script is provided under the MIT License.
