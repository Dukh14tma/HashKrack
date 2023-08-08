#!/bin/bash

# Define text formatting variables
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

# Display logo
logo="          _______  _______           _        _______  _______  _______  _
|\     /|(  ___  )(  ____ \\|\     /|| \\    /\\(  ____ )(  ___  )(  ____ \\| \    /\
| )   ( || (   ) || (    \\/| )   ( ||  \  / /| (    )|| (   ) || (    \\/|  \  / /
| (___) || (___) || (_____ | (___) ||  (_/ / | (____)|| (___) || |      |  (_/ /
|  ___  ||  ___  |(_____  )|  ___  ||   _ (  |     __)|  ___  || |      |   _ (
| (   ) || (   ) |      ) || (   ) ||  ( \ \ | (\ (   | (   ) || |      |  ( \\ \\
| )   ( || )   ( |/\\____) || )   ( ||  /  \ \\| ) \ \\__| )   ( || (____/\\|  /  \\  \\
|/     \\||/     \\|\\_______)|/     \\||_/    \\/|/   \\__/|/     \\|(_______/|_/    \\/
                                                                   Version: 0.2
                                                                                 "
clear

# Print logo and script information
echo "${bold}${green}$logo${reset}"
echo "${bold}${yellow}==============================================================================="
echo "${bold}${yellow}==============================Created By: dukh14tma============================"
echo "${bold}${yellow}===============================================================================${reset}"
echo

# Prompt user for input with colored text
read -p "${bold}${green}[+] Enter the hash to crack: ${yellow}" hash_to_crack
read -p "${bold}${green}[+] Enter the path to the wordlist file: ${yellow}" wordlist

# List of hashing algorithms
algorithms=(
  "md5" "sha1" "sha224" "sha256" "sha384" "sha512"
)

# Define the function to crack the hash
crack_hash() {
  local algorithm="$1"
  while read -r password; do
    case $algorithm in
      "md5")
        hash=$(echo -n "$password" | md5sum | awk '{print $1}')
        ;;
      "sha1")
        hash=$(echo -n "$password" | sha1sum | awk '{print $1}')
        ;;
      "sha224")
        hash=$(echo -n "$password" | sha224sum | awk '{print $1}')
        ;;
      "sha256")
        hash=$(echo -n "$password" | sha256sum | awk '{print $1}')
        ;;
      "sha384")
        hash=$(echo -n "$password" | sha384sum | awk '{print $1}')
        ;;
      "sha512")
        hash=$(echo -n "$password" | sha512sum | awk '{print $1}')
        ;;
    esac

    if [[ $hash == $hash_to_crack ]]; then
      echo -e "\n${bold}${green}Hash cracked using $algorithm! The password is: $password${reset}"
      kill -s TERM 0  # Terminate all background processes
      exit 0
    else
      echo -ne "${bold}${red}Checking password: $password${reset}\r"
    fi
  done < "$wordlist"
}

# Run hash cracking in background threads
for algorithm in "${algorithms[@]}"; do
  crack_hash "$algorithm" &
done

# Wait for all background jobs to finish
wait

echo -e "\n${bold}${red}Hash not found in the wordlist.${reset}"
exit 1
