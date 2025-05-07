#!/bin/bash

# Select date using Zenity calendar picker
selected_date=$(zenity --calendar --title="Select Date for Script Execution")

# Check if date was selected
if [[ -z "$selected_date" ]]; then
    zenity --error --text="No date selected. Exiting."
    exit 1
fi

# Prompt user for time in HH:MM format (12-hour)
time_input=$(zenity --entry --title="Select Time" --text="Enter time (HH:MM, 12-hour format):")

# Check if time was entered and is valid
if [[ ! "$time_input" =~ ^(0[1-9]|1[0-2]):[0-5][0-9]$ ]]; then
    zenity --error --text="Invalid time format. Please use HH:MM in 12-hour format."
    exit 1
fi

# Select AM/PM
ampm=$(zenity --list --title="AM or PM" --column="Period" AM PM)

if [[ -z "$ampm" ]]; then
    zenity --error --text="No AM/PM selection made. Exiting."
    exit 1
fi

# Convert 12-hour time to 24-hour
hour12=${time_input%%:*}
minute=${time_input##*:}

if [[ "$ampm" == "PM" && "$hour12" -ne 12 ]]; then
    hour=$((10#$hour12 + 12))
elif [[ "$ampm" == "AM" && "$hour12" -eq 12 ]]; then
    hour=0
else
    hour=$((10#$hour12))
fi

# Select script file
script_path=$(zenity --file-selection --title="Select Script to Schedule" --file-filter="*.sh")

if [[ -z "$script_path" ]]; then
    zenity --error --text="No script selected. Exiting."
    exit 1
fi

# Ask if DISPLAY/XAUTHORITY are needed
use_display=$(zenity --question --title="GUI Required?" --text="Does the script require GUI (Zenity, etc.)?" --ok-label="Yes" --cancel-label="No"; echo $?)

if [[ "$use_display" -eq 0 ]]; then
    display="DISPLAY=:0"
    xauthority="XAUTHORITY=/home/$USER/.Xauthority"
else
    display=""
    xauthority=""
fi

# Select repetition schedule
repeat=$(zenity --list --title="Repetition Schedule" --column="Repeat" "Once a day" "Once a week" "Once a month" "Once a year")

if [[ -z "$repeat" ]]; then
    zenity --error --text="No repetition option selected. Exiting."
    exit 1
fi

# Parse selected date
day=$(date -d "$selected_date" +%d)
month=$(date -d "$selected_date" +%m)
weekday=$(date -d "$selected_date" +%u) # 1 (Mon) to 7 (Sun)

# Build cron schedule
case "$repeat" in
    "Once a day")
        cron_time="$minute $hour * * *"
        ;;
    "Once a week")
        cron_time="$minute $hour * * $weekday"
        ;;
    "Once a month")
        cron_time="$minute $hour $day * *"
        ;;
    "Once a year")
        cron_time="$minute $hour $day $month *"
        ;;
esac

# Compose full cron command
cron_cmd="$cron_time $display $xauthority bash \"$script_path\""

# Add to user's crontab
(crontab -l 2>/dev/null; echo "$cron_cmd") | crontab -

# Confirmation
zenity --info --text="Cron job scheduled successfully for:\n$repeat\nAt: $hour:$minute\nDate: $selected_date"
