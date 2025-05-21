#!/bin/sh

# Constants
# ANSI Colour Codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Error Codes
readonly SUCCESS=0

readonly ERR_NOINSTALL=1
readonly ERR_FETCH=2
readonly ERR_MOVE=3
readonly ERR_INVALID=10
readonly ERR_UNEXPECTED=11


# Function Definitions
# Check if the specified editor is installed
check_installed() {
  case $1 in
    1)
      if which code > /dev/null 2>&1; then
        return $SUCCESS
      else
        return $ERR_NOINSTALL
      fi
      ;;

    *)
      return $ERR_UNEXPECTED
  esac
}


# Fetch and configure the editor settings
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
      return $ERR_UNEXPECTED
      ;;
  esac

  echo "${BLUE}[INFO]${NC} Fetching configuration files..."

  curl -L -# $SOURCE/$editor/settings.json -o $DIR_TEMP/settings.json && \
  curl -L -# $SOURCE/$editor/keybindings.json -o $DIR_TEMP/keybindings.json

  if [ $? -ne 0 ]; then
    return $ERR_FETCH
  fi

  echo "${BLUE}[INFO]${NC} Configuring ${YELLOW}$editor${NC}..."

  mv $DIR_TEMP/settings.json $DIR_CONFIG_CODE && \
  mv $DIR_TEMP/keybindings.json $DIR_CONFIG_CODE

  if [ $? -ne 0 ]; then
    return $ERR_MOVE
  fi

  return $SUCCESS
}


main() {
  local status

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
      status=$?

      if [ $status -eq $SUCCESS ]; then
        echo "Found ${GREEN}Code${NC} installation..."
      elif [ $status -eq $ERR_NOINSTALL ]; then
        echo "${RED}[ERROR]${NC} Cannot find the Code installation!"
        exit $ERR_NOINSTALL
      else
        echo "${RED}[ERROR]${NC} An unexpected error occurred while checking for Code installation!"
        exit $ERR_UNEXPECTED
      fi

      run_config 1
      status=$?

      if [ $status -eq $SUCCESS ]; then
        echo "Successfully configured ${GREEN}Code${NC}."
        echo ""
        echo "-----------------------------------"
        echo "Configuration process finished."

        exit $SUCCESS
      elif [ $status -eq $ERR_FETCH ]; then
        echo "${RED}[ERROR]${NC} Failed to configure Code. Please check your internet connection!"
        exit $ERR_FETCH
      elif [ $status -eq $ERR_MOVE ]; then
        echo "${RED}[ERROR]${NC} Failed to configure Code. Please check your file permissions!"
        exit $ERR_MOVE
      else
        echo "${RED}[ERROR]${NC} An unexpected error occurred while configuring Code!"
        exit $ERR_UNEXPECTED
      fi
      ;;

    q|Q)
      echo "Exiting..."
      exit $SUCCESS
      ;;

    *)
      echo "${RED}[ERROR]${NC} Invalid choice. Please try again!"
      exit $ERR_INVALID
      ;;
  esac
}

main
