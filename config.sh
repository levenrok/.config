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

    2)
      if which geany > /dev/null 2>&1; then
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
  readonly DIR_CONFIG_GEANY=$DIR_CONFIG/geany
  readonly DIR_TEMP=/tmp

  local editor
  local editor_dir_config

  case $1 in
    1)
      editor=Code
      editor_dir_config=$DIR_CONFIG_CODE
      ;;

    2)
      editor=Geany
      editor_dir_config=$DIR_CONFIG_GEANY
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

  mv $DIR_TEMP/settings.json $editor_dir_config && \
  mv $DIR_TEMP/keybindings.json $editor_dir_config

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
  echo "  [2] Geany"
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

    2)
      echo "Checking for ${BLUE}Geany${NC} installation..."

      check_installed 2
      status=$?

      if [ $status -eq $SUCCESS ]; then
        echo "Found ${GREEN}Geany${NC} installation..."
      elif [ $status -eq $ERR_NOINSTALL ]; then
        echo "${RED}[ERROR]${NC} Cannot find the Geany installation!"
        exit $ERR_NOINSTALL
      else
        echo "${RED}[ERROR]${NC} An unexpected error occurred while checking for Geany installation!"
        exit $ERR_UNEXPECTED
      fi

      run_config 2
      status=$?

      if [ $status -eq $SUCCESS ]; then
        echo "Successfully configured ${GREEN}Geany${NC}."
        echo ""
        echo "-----------------------------------"
        echo "Configuration process finished."

        exit $SUCCESS
      elif [ $status -eq $ERR_FETCH ]; then
        echo "${RED}[ERROR]${NC} Failed to configure Geany. Please check your internet connection!"
        exit $ERR_FETCH
      elif [ $status -eq $ERR_MOVE ]; then
        echo "${RED}[ERROR]${NC} Failed to configure Geany. Please check your file permissions!"
        exit $ERR_MOVE
      else
        echo "${RED}[ERROR]${NC} An unexpected error occurred while configuring Geany!"
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
