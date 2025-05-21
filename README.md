# .Config

This project contains the configuration files for code editors I use.The shell script in here automates the configuration process. It fetches configuration files from a this repository and applies them to the editors.

## Prerequisites

- A Unix-based operating system with a shell (`sh`).
- `curl` installed for fetching remote files.
- `mv` command available for moving files.

## Usage

1. Clone the repository or download the script.
2. Open a terminal and navigate to the directory containing `config.sh`.
3. Run the script:

   ```bash
   ./config.sh
   ```

4. Follow the prompts to select the editor you want to configure.

## Configuration Files

### Visual Studio Code
- `settings.json`: Contains editor settings such as font size, word wrap, and minimap visibility.
- `keybindings.json`: Defines custom keybindings for various editor actions.

### Geany
- `geany.conf`: Main configuration file for Geany, including editor preferences and UI settings.
- `keybindings.conf`: Defines custom keybindings for Geany.

## Error Codes

The script uses the following error codes to indicate issues:

- `0`: Success
- `1`: Editor not installed
- `2`: Failed to fetch configuration files
- `3`: Failed to move configuration files
- `1`0: Invalid input
- `1`1: Unexpected error
