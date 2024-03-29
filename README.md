# Silver Guide

Silver Guide is a simple and versatile command-line tool for managing your projects and their paths effortlessly. Whether you are a developer working on multiple projects or an organizer handling various tasks, Silver Guide helps you organize and access your project information with ease.

## Features

- **Project Management:** Create, retrieve, and list projects with just a few commands.
- **Path Normalization:** Silver Guide intelligently normalizes paths for consistent and reliable storage.
- **Cross-Platform Compatibility:** Install and use Silver Guide seamlessly on both Unix-like systems (Linux, macOS) and Windows.
- **Effortless Installation:** A universal installation script sets up the `filemark` command, making it ready for immediate use.

## Getting Started

1. Clone the repository:

    ```bash
    git clone https://github.com/Shreyas-Ashtamkar/silver-guide.git
    ```

2. Navigate to the cloned repository:

    ```bash
    cd silver-guide
    ```

3. Run the universal installation script:

    - **On Unix-like systems (Linux or macOS):**

        ```bash
        cd bin
        ./install_filemark.sh
        ```

    - **On Windows:**

        - For PowerShell:

            ```powershell
            cd bin
            .\install_filemark.ps1
            ```

        - For CMD:

            ```cmd
            cd bin
            .\install_filemark.cmd
            ```

Explore the powerful commands of Silver Guide and take control of your project organization effortlessly.
## Commands

After the installation, you can use the `filemark` command to manage projects and their paths.

### Examples

- **Create a new project:**

    ```bash
    filemark --name "Project X" --path "/path/to/projectX"
    ```

- **Fetch a project by ID or name:**

    ```bash
    filemark --get 1
    ```

    ```bash
    filemark --get "Project X"
    ```

- **List all projects:**

    ```bash
    filemark --get
    ```

- **Open the folder in the current terminal:**

    ```bash
    filemark --open "Project X"
    ```

<!-- Refer to the [Manage Projects Documentation](link-to-detailed-documentation) for more details on available commands and options. -->

## Supports

- Python 3.*
- Processing4
ਠ