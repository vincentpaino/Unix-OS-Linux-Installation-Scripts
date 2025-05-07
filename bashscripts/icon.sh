#!/bin/bash

# Prompt user to select the script (.sh file)
script_path=$(zenity --file-selection --title="Select a Shell Script to Create Shortcut" --file-filter="*.sh")

# If no script selected, exit
if [[ -z "$script_path" ]]; then
    zenity --error --text="No script selected. Exiting."
    exit 1
fi

# Prompt user to select an image for the icon
icon_path=$(zenity --file-selection --title="Select an Icon Image" --file-filter="Images | *.png *.jpg *.jpeg *.svg *.ico")

# If no image selected, exit
if [[ -z "$icon_path" ]]; then
    zenity --error --text="No icon selected. Exiting."
    exit 1
fi

# Prompt user to enter a name for the desktop entry
entry_name=$(zenity --entry --title="Shortcut Name" --text="Enter a name for your desktop shortcut:")

# If no name entered, use a default name
if [[ -z "$entry_name" ]]; then
    entry_name="MyShellScript"
fi

# Define the path for the .desktop file (in current directory)
desktop_file="./$entry_name.desktop"

# Create the .desktop file
echo "[Desktop Entry]" > "$desktop_file"
echo "Type=Application" >> "$desktop_file"
echo "Name=$entry_name" >> "$desktop_file"
echo "Exec=$script_path" >> "$desktop_file"
echo "Icon=$icon_path" >> "$desktop_file"
echo "Terminal=true" >> "$desktop_file"

# Copy the .desktop file to user's desktop
cp "$desktop_file" "$HOME/Desktop/"

# Make the .desktop file executable
chmod +x "$HOME/Desktop/$entry_name.desktop"

# Notify user
zenity --info --text="Shortcut '$entry_name.desktop' has been created on your desktop!"
