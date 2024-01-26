#!/bin/bash

# Define variables
pythonScriptPath="$PWD/../filemark.py"
scriptPath="./filemark.sh"

# Define function to uninstall
uninstall() {
    echo "Uninstalling..."
    rm -f "$scriptPath" # Remove the script file
    sed -i '/# FILEMARK START/,/# FILEMARK END/d' "$profilePath" # Remove the added lines from the profile file
    echo "Uninstallation complete."
    exit 0
}

# Check if --uninstall parameter is provided
if [[ "$1" == "--uninstall" ]]; then
    uninstall
fi

# Get the default shell of the user from /etc/passwd
curr_shell="$(getent passwd "$USER" | cut -d: -f7)"

# Check the current shell
if [[ $curr_shell == *"bash"* ]]; then
    # Bash
    profilePath="$HOME/.bashrc"
    echo "# FILEMARK START" > "$scriptPath"
    echo "#!$(which bash)" >> "$scriptPath"
    echo "alias filemark=\"python3 \\\"$pythonScriptPath\\\" \\\"\$@\\\"\"" >> "$scriptPath"
    echo "# FILEMARK END" >> "$scriptPath"
elif [[ $curr_shell == *"zsh"* ]]; then
    # Zsh
    profilePath="$HOME/.zshrc"
    echo "# FILEMARK START" > "$scriptPath"
    echo "#!$(which zsh)" >> "$scriptPath"
    echo "alias filemark=\"python3 \\\"$pythonScriptPath\\\" \\\"\$@\\\"\"" >> "$scriptPath"
    echo "# FILEMARK END" >> "$scriptPath"
elif [[ $curr_shell == *"fish"* ]]; then
    # Fish
    profilePath="$HOME/.config/fish/config.fish"
    echo "# FILEMARK START" > "$scriptPath"
    echo "function filemark" >> "$scriptPath"
    echo "    python3 \"$pythonScriptPath\" \$argv" >> "$scriptPath"
    echo "# FILEMARK END" >> "$scriptPath"
else
    echo "Error: Unsupported shell. Please configure 'filemark' alias manually."
    exit 1
fi

# Make the script executable
chmod +x "$scriptPath"

# Append or create the alias in the shell configuration file
echo "Appending alias to $profilePath"
echo >> "$profilePath"
cat "$scriptPath" >> "$profilePath"

echo "Installation complete. You can now use 'filemark' in the terminal."
