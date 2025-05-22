#!/bin/bash

# -------------------------------------------------------------------
# 📁 Folder Readability Checker Script
#
# This script asks the user to input the path to a folder.
# It performs the following tasks:
# 
# 1. Replaces '~' with the actual home directory path.
# 2. Checks if the given path is a valid folder.
# 3. Checks if the folder is empty.
# 4. If not empty, it loops through all items and:
#    - Checks if each file or folder has read permission.
#    - Prints the name of readable files 📄 and folders 📁.
# 5. If no readable items are found, it notifies the user.
#
# Helpful for verifying access to files and debugging permission issues.
# -------------------------------------------------------------------


# Prompt user to enter the path to a folder
read -p "📂 Enter the path to the folder (e.g., ~/Desktop/test): " folder_path

# Replace ~ with the home directory path
folder_path="${folder_path/#\~/$HOME}"

# Check if the path is a valid directory
if [ ! -d "$folder_path" ]; then
    echo "❌ Error: '$folder_path' is not a valid folder or does not exist."
    exit 1
fi

# Check if the folder is empty
if [ -z "$(ls -A "$folder_path")" ]; then
    echo "😿 The folder '$folder_path' is empty."
    exit 0
fi

# List files and folders with read permission
echo "📋 Files and folders in '$folder_path' with read permission:"
found_readable=false

# Loop through all items in the folder
for item in "$folder_path"/*; do
    if [ -r "$item" ]; then
        if [ -f "$item" ]; then
            echo "📄 File: $(basename "$item")"
        elif [ -d "$item" ]; then
            echo "📁 Folder: $(basename "$item")"
        fi
        found_readable=true
    fi
done

# If no readable items were found
if [ "$found_readable" = false ]; then
    echo "😕 No files or folders with read permission found."
fi


