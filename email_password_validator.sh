#! /bin/bash 

# 🔐 Email and Password Validator Script
#
# This script prompts the user to enter a valid email and a strong password.
# It validates the inputs and saves them to a file if both are correct.
#
# ✅ Email must match: name@domain.tld
# ✅ Password must be at least 8 characters long, including:
#    - One uppercase letter
#    - One lowercase letter
#    - One number
#
# 🔁 The script uses `while` loops to repeatedly ask the user 
#     until valid input is received.
#
# 📁 Output is saved to:
#   /home/zizi/Desktop/output_file

output_file="/home/zizi/Desktop/output_file"

# ✉️ Email validation loop
while true; do
  echo "Enter your email:"
  read email
  if [[ $email =~ ^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "✅ Valid email"
    break
  else
    echo "❌ Invalid email format. Try again."
  fi
done

# 🔐 Password validation loop
while true; do
  echo "Enter your password:"
  read -s pass  # Hide password while typing
  echo
  if [[ "$pass" =~ [A-Z] ]] && [[ "$pass" =~ [a-z] ]] && [[ "$pass" =~ [0-9] ]] && [[ ${#pass} -ge 8 ]]; then
    echo "✅ Valid password"
    break
  else
    echo "❌ Invalid password. Must be 8+ chars, include upper/lowercase and number."
  fi
done

# 💾 Save to file
echo "email:$email" >> "$output_file"
echo "pass:$pass" >> "$output_file"
echo "✅ Saved to $output_file 📁"













