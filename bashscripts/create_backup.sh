#!/bin/bash

# Use Zenity to select a source directory
source_dir=$(zenity --file-selection --directory --title="Select Source Directory to Backup")

# Check if user canceled
if [[ -z "$source_dir" ]]; then
    zenity --error --text="No source directory selected. Exiting."
    exit 1
fi

# Use Zenity to select destination directory
dest_dir=$(zenity --file-selection --directory --title="Select Destination Directory for Backup")

# Check if user canceled
if [[ -z "$dest_dir" ]]; then
    zenity --error --text="No destination directory selected. Exiting."
    exit 1
fi

# Create a timestamped tarball of the source directory
timestamp=$(date +%Y%m%d_%H%M%S)
backup_name="backup_$(basename "$source_dir")_$timestamp.tar.gz"
backup_path="$dest_dir/$backup_name"

# Create the tarball
if tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"; then
    zenity --info --text="Backup successful!\nSaved to:\n$backup_path"
else
    zenity --error --text="Backup failed!"
    exit 1
fi
