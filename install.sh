#!/bin/bash

# Function to detect the operating system and architecture
detect_os_and_arch() {
    OS=""
    ARCH=""

    case "$(uname -s)" in
        Linux*)     OS="linux"; ARCH="x64" ;;
        Darwin*)    OS="macos"; ARCH="x64" ;;
        CYGWIN*|MINGW*|MSYS*) OS="windows"; ARCH="x64" ;;
        *)          echo "Unsupported OS"; exit 1 ;;
    esac

    echo "$OS-$ARCH"
}

# Function to fetch the latest release asset URL from GitHub
fetch_latest_release_url() {
    local repo_owner="holasoymas"
    local repo_name="text-finder"
    local os_arch="$1"

    # Fetch the latest release information from GitHub API
    local release_info=$(curl -s "https://api.github.com/repos/$repo_owner/$repo_name/releases/latest")

    # Extract the download URL for the specific OS and architecture
    local asset_url=""
    case "$os_arch" in
        linux-x64)      asset_url=$(echo "$release_info" | grep '"browser_download_url":.*text-finder-linux-x64"' | cut -d '"' -f 4) ;;
        macos-x64)      asset_url=$(echo "$release_info" | grep '"browser_download_url":.*text-finder-macos-x64"' | cut -d '"' -f 4) ;;
        windows-x64)    asset_url=$(echo "$release_info" | grep '"browser_download_url":.*text-finder-windows-x64.exe"' | cut -d '"' -f 4) ;;
        *)              echo "Unsupported OS/architecture: $os_arch"; exit 1 ;;
    esac

    if [ -z "$asset_url" ]; then
        echo "No matching asset found for $os_arch in the latest release."
        exit 1
    fi
    echo "$asset_url"
}

main() {
    echo "Detecting OS and architecture..."
    os_arch=$(detect_os_and_arch)
    echo "Detected: $os_arch"

    echo "Fetching the latest release URL..."
    asset_url=$(fetch_latest_release_url "$os_arch")
    if [ $? -ne 0 ]; then
        echo "Failed to fetch the latest release URL. Exiting..."
        exit 1
    fi
    echo "Latest release URL: $asset_url"

    # Create a temporary directory for downloading the asset
    temp_dir=$(mktemp -d)
    echo "Downloading the asset to $temp_dir..."
    curl -L "$asset_url" -o "$temp_dir/text-finder"
    if [ $? -ne 0 ]; then
        echo "Failed to download the asset. Exiting..."
        rm -rf "$temp_dir"
        exit 1
    fi

    # Make the downloaded file executable
    chmod +x "$temp_dir/text-finder"
    if [ $? -ne 0 ]; then
        echo "Failed to make the file executable. Exiting..."
        rm -rf "$temp_dir"
        exit 1
    fi

    # Install to a user-writable directory
    local install_dir="$HOME/.local/bin"
    mkdir -p "$install_dir"
    mv "$temp_dir/text-finder" "$install_dir/text-finder"
    if [ $? -ne 0 ]; then
        echo "Failed to move the file to the installation directory. Exiting..."
        rm -rf "$temp_dir"
        exit 1
    fi

    # Ensure $HOME/.local/bin is in the user's PATH
    update_path "$install_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to update the PATH. Exiting..."
        exit 1
    fi

    echo "Installation complete. Run 'text-finder /path/to/pdf \"search string\"' to use the tool."
}

# Function to update the user's PATH in their shell configuration file
update_path() {
    local install_dir="$1"
    local shell_config_file=""

    # Detect the shell configuration file
    if [ -f "$HOME/.bashrc" ]; then
        shell_config_file="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        shell_config_file="$HOME/.zshrc"
    else
        echo "Could not find a shell configuration file (.bashrc or .zshrc). Please add '$install_dir' to your PATH manually."
        return 1
    fi

    # Check if the PATH update is already present
    if ! grep -q "$install_dir" "$shell_config_file"; then
        echo "Adding '$install_dir' to PATH in $shell_config_file..."
        echo "export PATH=\"$install_dir:\$PATH\"" >> "$shell_config_file"
        
        # Automatically source the updated configuration file
        echo "Applying changes to your current shell session..."
        source "$shell_config_file"
        if [ $? -ne 0 ]; then
            echo "Failed to apply changes to your shell session. Please run 'source $shell_config_file' manually."
            return 1
        fi
    else
        echo "'$install_dir' is already in your PATH."
    fi

    return 0
}
# Run the main function
main
