#!/bin/bash
# 📨 Simple Email & Password Validator Script
# 
# This script prompts the user to enter an email 
# and a password, validates both based on format 
# and strength rules, and saves them to a file 
# if both are valid.
#
# ✅ Email must follow a basic pattern: name@domain.tld
# ✅ Password must be at least 8 characters long and contain:
#    - at least one uppercase letter
#    - at least one lowercase letter
#    - at least one number
#
# If both inputs are valid, they are saved to:
#   /home/zizi/Desktop/output_file



output_file="/home/zizi/Desktop/output_file"

echo "Please enter your email:"
read email

if [[ $email =~ ^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Your email is true ✅"

    echo "Please enter your password:"
    read  pass

    if [[ "$pass" =~ [A-Z] ]] && \
       [[ "$pass" =~ [a-z] ]] && \
       [[ "$pass" =~ [0-9] ]] && \
       [[ ${#pass} -ge 8 ]]; then
        echo "Your password is true ✅"
        
        echo "email:$email" >> "$output_file"
        echo "pass:$pass" >> "$output_file"
        echo "Saved to $output_file 📁"
    else
        echo "❌ Your password is invalid. Must be 8+ characters, upper, lower, number."
    fi
else
    echo "❌ Your email is invalid."
fi

