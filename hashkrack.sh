#!/bin/bash

# Define text formatting variables
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Display logo
logo="
          _______  _______           _        _______  _______  _______  _       
|\     /|(  ___  )(  ____ \|\     /|| \    /\(  ____ )(  ___  )(  ____ \| \    /\
| )   ( || (   ) || (    \/| )   ( ||  \  / /| (    )|| (   ) || (    \/|  \  / /
| (___) || (___) || (_____ | (___) ||  (_/ / | (____)|| (___) || |      |  (_/ / 
|  ___  ||  ___  |(_____  )|  ___  ||   _ (  |     __)|  ___  || |      |   _ (  
| (   ) || (   ) |      ) || (   ) ||  ( \ \ | (\ (   | (   ) || |      |  ( \ \ 
| )   ( || )   ( |/\____) || )   ( ||  /  \ \| ) \ \__| )   ( || (____/\|  /  \ \
|/     \||/     \|\_______)|/     \||_/    \/|/   \__/|/     \|(_______/|_/    \/
                                                                                 
"
clear

# Print logo
echo "${bold}${green}$logo${reset}"
echo

# Prompt user for input
read -p "${bold}${red}[+]${green}    Enter the hash to crack: " hash_to_crack
echo
read -p "${bold}${red}[+]${green}    Enter the path to the wordlist file: " wordlist ${reset}

# List of hashing algorithms
algorithms=("md5" "sha1" "sha224" "sha256" "sha384" "sha512" "ripemd160" "whirlpool" "tiger128,3" "tiger160,3" "tiger192,3" "tiger128,4" "tiger160,4" "tiger192,4" "snefru" "gost" "adler32" "crc32" "crc32b" "fnv132" "fnv164" "joaat" "haval128,3" "haval160,3" "haval192,3" "haval224,3" "haval256,3" "haval128,4" "haval160,4" "haval192,4" "haval224,4" "haval256,4" "haval128,5" "haval160,5" "haval192,5" "haval224,5" "haval256,5")

# Loop through algorithms and wordlist
for algorithm in "${algorithms[@]}"; do
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
      "ripemd160")
        hash=$(echo -n "$password" | openssl dgst -ripemd160 | awk '{print $2}')
        ;;
      "whirlpool")
        hash=$(echo -n "$password" | openssl dgst -whirlpool | awk '{print $2}')
        ;;
      "tiger128,3" | "tiger160,3" | "tiger192,3" | "tiger128,4" | "tiger160,4" | "tiger192,4")
        hash=$(echo -n "$password" | openssl dgst "-$algorithm" | awk '{print substr($0, length($0)-31)}')
        ;;
      "snefru" | "gost" | "adler32" | "crc32" | "crc32b" | "fnv132" | "fnv164" | "joaat" | "haval128,3" | "haval160,3" | "haval192,3" | "haval224,3" | "haval256,3" | "haval128,4" | "haval160,4" | "haval192,4" | "haval224,4" | "haval256,4" | "haval128,5" | "haval160,5" | "haval192,5" | "haval224,5"| "haval256,5")
        echo "${red}The algorithm '$algorithm' is not supported without OpenSSL. Please remove it from the 'algorithms' array to continue.${reset}"
        continue
        ;;
      *)  # Handle unknown algorithms
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
