#! /bin/bash

declare C_RED="\033[91m"
declare C_GREEN="\033[92m"
declare C_CYAN="\033[96m"
declare C_YELLOW="\033[93m"
declare C_WHITE="\033[97m"

# End of the color sequence
declare NO_FORMAT="\033[0m"

main() {

        echo -e "${C_WHITE}Do you want to link ${C_CYAN}\"/run/systemd/resolve/stub-resolv.conf\"${NO_FORMAT} to ${C_CYAN}\"/etc/resolv.conf\"${C_WHITE}? ${NO_FORMAT} [Y/n] -> \c"

        declare ans_enable_dns=""
        read ans_enable_dns
        : "${ans_enable_dns:=Y}"
        echo ""

        case "${ans_enable_dns}" in
                "y"|"Y")
                        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
                        if [[ -L "/etc/resolv.conf" ]]; then
                                echo -e "${C_GREEN}The link has been created. ${C_WHITE}Exiting.${NO_FORMAT}"
                        else
                                echo -e "${C_RED}The link has not been created. An error occured. You may want to execute the command \"ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf\" manually. ${C_WHITE}Exiting.${NO_FORMAT}"

                        ;;
                "n"|"N")
                        echo -e "${C_YELLOW}Nothing has been done.${NO_FORMAT}"
                        ;;
        esac

        exit 0 
}

main
