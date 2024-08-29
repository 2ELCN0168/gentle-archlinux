opt_h_help() {
        echo -e "\n${C_WHITE}Welcome to this automated ${C_CYAN}Archlinux${C_WHITE} installer!${NO_FORMAT}\n"
        echo -e "This script aims to automate in a better way than the archinstall script, the Archlinux installation."
        echo -e "There are a lot of options to discover and the script is designed to propose a lot of options."
        echo -e "Before launching it, it's recommended to try it in a virtual machine.\n"
        echo -e "${C_CYAN}Options:${NO_FORMAT}\n"
        echo -e "${C_BLUE}  -h${C_WHITE}   Display this help.${NO_FORMAT}"
        echo -e "${C_BLUE}  -e${C_WHITE}   Enable hardening mode.${NO_FORMAT}"
        echo -e "${C_BLUE}  -m${C_WHITE}   Minimal installation.${NO_FORMAT}"
        echo -e "${C_BLUE}  -c${C_WHITE}   Full detailed installation.${NO_FORMAT}"
        echo -e "\n"
        exit 0
}
