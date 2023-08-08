#!/bin/bash

# Define text formatting variables
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Display logo
logo="
          _______  _______           _        _______  _______  _______  _
|\     /|(  ___  )(  ____ \\|\     /|| \\    /\\(  ____ )(  ___  )(  ____ \\| \    /\

| )   ( || (   ) || (    \\/| )   ( ||  \\  / /| (    )|| (   ) || (    \\/|  \\  / /
| (___) || (___) || (_____ | (___) ||  (_/ / | (____)|| (___) || |      |  (_/ /
|  ___  ||  ___  |(_____  )|  ___  ||   _ (  |     __)|  ___  || |      |   _ (
| (   ) || (   ) |      ) || (   ) ||  ( \\ \\ | (\\ (   | (   ) || |      |  ( \\ \\
| )   ( || )   ( |/\\____) || )   ( ||  /  \\ \\| ) \\ \\__| )   ( || (____/\\|  /  \ \

|/     \\||/     \\|\\_______)|/     \\||_/    \\/|/   \\__/|
echo "${bold}${green}$logo${reset}"
echo

# Prompt user for input
read -p "${bold}${red}[+]${green}    Enter the hash to crack: " hash_to_crack
echo
read -p "${bold}${red}[+]${green}    Enter the path to the wordlist file: " wordlist
echo "${reset}"

# List of hashing algorithms
algorithms=("md5" "sha1" "sha224" "sha256" "sha384" "sha512" "ripemd160" "whirlpool" "tiger128,3" "tiger160,3" "tiger192,3" "tiger128,4" "tiger160,4" "tiger192,4")

# Loop through algorithms and wordlist
for algorithm in "${algorithms[@]}"; do
  while read -r password; do
    case $algorithm in
      "md5" | "sha1" | "sha224" | "sha256" | "sha384" | "sha512" | "ripemd160" | "whirlpool" | "tiger128,3" | "tiger160,3" | "tiger192,3" | "tiger128,4" | "tiger160,4" | "tiger192,4")
        hash=$(echo -n "$password" | openssl dgst "-$algorithm" | awk '{print $2}')
        ;;
      *)
        echo "${red}Unknown hashing algorithm: $algorithm${reset}"
        continue
        ;;
    esac

    if [[ $hash == $hash_to_crack ]]; then
      echo "${bold}${green}Hash cracked using $algorithm! The password is: $password${reset}"
      exit 0
    fi
  done < "$wordlist"
done

echo "${bold}${red}Hash not found in the wordlist.${reset}"
