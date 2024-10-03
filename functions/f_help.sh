#
### File: f_help.sh
#
### Description: 
# Print the help menu if an option is illegal or -h is written.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
#
### Dependencies:
# - none. 
#
### Usage:
#
# 1. It just prints the help menu. Parameters are in the main file.
#

opt_h_help() {
        echo -e "\n${C_WHITE}Welcome to this automated ${C_CYAN}Archlinux" \
                "${C_WHITE}installer!${NO_FORMAT}\n"
        echo -e "This script aims to automate in a better way than the" \
                "archinstall script, the Archlinux installation."
        echo -e "There are a lot of options to discover and the script is" \
                "designed to propose the most user friendly customization."
        echo -e "Before using it, it's recommended to try it in a virtual" \
                "machine.\n"
        echo -e "To install a Graphical User Interface (Desktop" \
                "Environment only), use the -c parameter.\n"
        echo -e "${C_CYAN}Options:${NO_FORMAT}\n"
        echo -e "${C_BLUE}  -h${C_WHITE}   Display this help.${NO_FORMAT}"
        echo -e "${C_BLUE}  -e${C_WHITE}   Enable hardening mode" \
                "(Enhanced security).${NO_FORMAT}"
        echo -e "${C_BLUE}  -m${C_WHITE}   Minimal installation (Fast" \
                "with default options).${NO_FORMAT}"
        echo -e "${C_BLUE}  -c${C_WHITE}   Full detailed installation" \
                "(Complete customization).${NO_FORMAT}"
        echo -e "\n"
        exit 0
}
