#!/bin/bash

INPUT_FILE="cases.csv"
BASE_DIR="Cases"

mkdir -p "$BASE_DIR"

tail -n +2 "$INPUT_FILE" | while IFS=',' read -r name type status description
do
    # حذف کاراکترهای اضافی و جایگزینی اسپیس با _
    clean_name=$(echo "$name" | sed 's/ /_/g')
    case_dir="$BASE_DIR/$type"
    file_path="$case_dir/$clean_name"

    # ساخت پوشه نوع پرونده اگه وجود نداره
    mkdir -p "$case_dir"

    # ایجاد فایل و نوشتن توضیحات
    echo "$description" > "$file_path"

    # تنظیم دسترسی‌ها
    if [[ "$status" == "Solved" ]]; then
        chmod 644 "$file_path"   # -rw-r--r--
    elif [[ "$status" == "In Progress" ]]; then
        chmod 640 "$file_path"   # -rw-r-----
    elif [[ "$status" == "Not Started" ]]; then
        chmod 400 "$file_path"   # -r--------
    fi
done
