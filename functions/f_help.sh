#
### File: f_help.sh
#
### Description: 
# Print the help menu if an option is illegal or -h is written.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - none. 
#
### Usage:
#
# 1. It just prints the help menu. Parameters are in the main file.
#

opt_h_help() {
        printf "\n${C_W}Welcome to this automated ${C_C}Archlinux "
        printf "${C_W}installer!${N_F}\n\n"

        printf "This script aims to automate in a better way than the "
        printf "archinstall script, the Archlinux installation.\n"
        printf "There are a lot of options to discover and the script is "
        printf "designed to propose the most user friendly customization.\n"
        printf "Before using it, it's recommended to try it in a virtual "
        printf "machine.\n\n"

        printf "To install a Graphical User Interface (Desktop Environment "
        printf "only), use the -c parameter.\n\n"

        printf "${C_C}Options:${N_F}\n\n"
        printf "${C_B}  -h${C_W}   Display this help.${N_F}\n"
        printf "${C_B}  -e${C_W}   Enable hardening mode (Enhanced "
        printf "security).${N_F}\n"
        printf "${C_B}  -m${C_W}   Minimal installation (Fast with default "
        printf "options).${N_F}\n"
        printf "${C_B}  -c${C_W}   Full detailed installation "
        printf "(Complete customization).${N_F}\n"
        printf "\n"
        exit 0
}
