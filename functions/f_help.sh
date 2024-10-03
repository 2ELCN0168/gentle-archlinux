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
        echo -e "\n${C_W}Welcome to this automated ${C_C}Archlinux" \
                "${C_W}installer!${N_F}\n"
        echo -e "This script aims to automate in a better way than the" \
                "archinstall script, the Archlinux installation."
        echo -e "There are a lot of options to discover and the script is" \
                "designed to propose the most user friendly customization."
        echo -e "Before using it, it's recommended to try it in a virtual" \
                "machine.\n"
        echo -e "To install a Graphical User Interface (Desktop" \
                "Environment only), use the -c parameter.\n"
        echo -e "${C_C}Options:${N_F}\n"
        echo -e "${C_B}  -h${C_W}   Display this help.${N_F}"
        echo -e "${C_B}  -e${C_W}   Enable hardening mode" \
                "(Enhanced security).${N_F}"
        echo -e "${C_B}  -m${C_W}   Minimal installation (Fast" \
                "with default options).${N_F}"
        echo -e "${C_B}  -c${C_W}   Full detailed installation" \
                "(Complete customization).${N_F}"
        echo -e "\n"
        exit 0
}
