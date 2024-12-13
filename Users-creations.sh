#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Function to generate a random password
generate_password() {
    local password_length=12
    # Generate a random password of specified length
    tr -dc 'A-Za-z0-9!@#$%&*' </dev/urandom | head -c $password_length
}

# Check if at least one username is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 username1 [username2 ...]" >&2
    exit 1
fi

# Iterate over all usernames passed as arguments
USERNAMES="$@"
for USERNAME in ${USERNAMES}; do
    # Check if the user already exists
    EXISTING_USER=$(getent passwd "$USERNAME" | cut -d: -f1)
    if [ $USERNAME == $EXISTING_USER ] &>/dev/null; then
        echo "User '$USERNAME' already exists."
        continue
    fi

    # Generate a random password for the user
    password=$(generate_password)

    # Create the user with the generated password
    useradd -m "$USERNAME" -s /bin/bash
    echo "$USERNAME:$password" | chpasswd

    # Force the user to change the password on first login
    passwd --expire "$USERNAME"

    # Display the created user's credentials
    echo "User '$USERNAME' created successfully."
    echo "Temporary password: $password"

done
