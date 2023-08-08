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
  "ripemd160" "whirlpool" "tiger128,3" "tiger160,3"
  "tiger192,3" "tiger128,4" "tiger160,4" "tiger192,4"
  "snefru" "gost" "adler32" "crc32" "crc32b" "fnv132"
  "fnv164" "joaat" "haval128,3" "haval160,3" "haval192,3"
  "haval224,3" "haval256,3" "haval128,4" "haval160,4"
  "haval192,4" "haval224,4" "haval256,4" "haval128,5"
  "haval160,5" "haval192,5" "haval224,5" "haval256,5"
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
      # ... (other algorithm cases)
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
