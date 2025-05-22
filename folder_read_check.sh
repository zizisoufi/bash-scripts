#!/bin/bash
# ---------------------------------------------------------------------------
# 📂 Folder Readable Content Checker
#
# This Bash script prompts the user to enter a path to a folder and performs:
#
# 1. Resolves the path using 'realpath -m' to normalize it (handle ~, ., .., etc.)
# 2. Checks if the path exists and is a valid directory.
# 3. Verifies whether the folder is empty.
# 4. If not empty, it loops through all files/folders inside the given path and:
#    ✅ Checks if each item is readable (-r).
#    📄 Prints the name if it's a file.
#    📁 Prints the name if it's a folder.
# 5. If no readable items are found, notifies the user.
#
# 🔍 Useful for checking read permissions and inspecting folder contents quickly.
# ---------------------------------------------------------------------------


read -p "📂 Enter the path to the folder (e.g., ~/Desktop/test): " folder_path

folder_path=$(realpath -m "$folder_path")

if [ ! -d "$folder_path" ]; then
    echo "❌ Error: '$folder_path' is not a valid folder or does not exist."
    exit 1
fi

if [ -z "$(ls -A "$folder_path")" ]; then
    echo "😿 The folder '$folder_path' is empty."
    exit 0
fi

echo "📋 Files and folders in '$folder_path' with read permission:"
found_readable=false

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

if [ "$found_readable" = false ]; then
    echo "😕 No files or folders with read permission found."
fi

