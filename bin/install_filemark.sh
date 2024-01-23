#!/bin/bash

# Define variables
pythonScriptPath="$PWD/../filemark.py"
scriptPath="./filemark.sh"

# Check the current shell
if [ -n "$BASH_VERSION" ]; then
    # Bash
    profilePath="$HOME/.bashrc"
    echo "alias filemark=\"python3 \\\"$pythonScriptPath\\\" \\\"\$@\\\"\"" > "$scriptPath"
elif [ -n "$ZSH_VERSION" ]; then
    # Zsh
    profilePath="$HOME/.zshrc"
    echo "alias filemark=\"python3 \\\"$pythonScriptPath\\\" \\\"\$@\\\"\"" > "$scriptPath"
elif command -v fish >/dev/null 2>&1; then
    # Fish
    profilePath="$HOME/.config/fish/config.fish"
    echo "function filemark" > "$scriptPath"
    echo "    python3 \"$pythonScriptPath\" \$argv" >> "$scriptPath"
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
