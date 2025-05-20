#!/bin/sh

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'


check_installed() {
  case $1 in
    1)
      if which code > /dev/null 2>&1; then
        return 1
      else
        return 0
      fi
      ;;

    *)
      echo "${RED}[ERROR]${NC} Invalid argument passed to check_installed function."
      return 1
  esac
}

run_config() {
  readonly SOURCE=https://github.com/levenrok/.config/raw/refs/heads/main

  readonly DIR_CONFIG=~/.config
  readonly DIR_CONFIG_CODE=$DIR_CONFIG/Code/User
  readonly DIR_TEMP=/tmp

  local editor

  case $1 in
    1)
      editor=Code
      ;;

    *)
      echo "${RED}[ERROR]${NC} Invalid editor choice passed to run_config function."
      return 1
      ;;
  esac

  echo "${BLUE}[INFO]${NC} Fetching configuration files..."

  curl -L -# $SOURCE/$editor/settings.json -o $DIR_TEMP/settings.json
  curl -L -# $SOURCE/$editor/keybindings.json -o $DIR_TEMP/keybindings.json

  echo "Configuring ${YELLOW}$editor${NC}..."

  mv $DIR_TEMP/settings.json $DIR_CONFIG_CODE
  mv $DIR_TEMP/keybindings.json $DIR_CONFIG_CODE

  return 0
}


echo "
    .--.
   ||o|_o |
   |${YELLOW}:_/${NC} |
  //   \ \\
 (|     | )
/'\_   _/``\\
\___)=(___/
"
echo "Welcome to the ${BLUE}Auto Configurator!${NC}"
echo "-----------------------------------"
echo ""

echo "Please select the code editor to configure:"
echo "  [1] Code"
echo "  [q] Quit"
read -p "Enter your choice: " editor_choice
echo ""

case "$editor_choice" in
  1)
    echo "Checking for ${BLUE}Code${NC} installation..."

    check_installed 1

    if [ $? -eq 1 ]; then
      echo "Found ${GREEN}Code${NC} installation..."
    else
      echo "${RED}[ERROR]${NC} Cannot find the Code installation!"
      exit 1
    fi

    run_config 1

    if [ $? -eq 0 ]; then
      echo "Successfully configured ${GREEN}Code${NC}."
    else
      echo "${RED}[ERROR]${NC} Failed to configure Code. Please check your internet connection or file permissions!"
    fi
    ;;

  q|Q)
    echo "Exiting..."
    exit 0
    ;;

  *)
    echo "${RED}[ERROR]${NC} Invalid choice. Please try again!"
    ;;
esac

echo ""
echo "-----------------------------------"
echo "Configuration process finished."
