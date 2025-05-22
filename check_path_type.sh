#!/bin/bash

# ---------------------------------------------------------
# 📁 Path Type Checker Script
#
# This Bash script prompts the user to enter a path 
# (file or folder), checks if it exists, and then determines:
#   - whether it is a file 📄
#   - a directory 📁
#   - or some other type of object (like a symlink or device) 📦
#
# If the path does not exist, it informs the user ❌
# Useful for basic file system validation or debugging scripts.
# ---------------------------------------------------------






read -p "Enter the path to the file or folder: " path

if [ -e "$path" ]; then
    if [ -f "$path" ]; then
        echo "📄 This is a file."
    elif [ -d "$path" ]; then
        echo "📁 This is a folder."
    else
        echo "📦 This object exists, but it is neither a file nor a folder (e.g., a link or a device)"
    fi
else
    echo "❌ No such path exists."
fi
