#! /bin/bash

declare C_RED="\033[91m"
declare C_GREEN="\033[92m"
declare C_CYAN="\033[96m"
declare C_YELLOW="\033[93m"
declare C_WHITE="\033[97m"

# End of the color sequence
declare NO_FORMAT="\033[0m"

main() {

        if [[ "${EUID}" -ne 0 ]]; then
                echo -e "${C_WHITE}:: ${C_RED}This script must be executed as root. Exiting.${C_WHITE} ::${NO_FORMAT}"
                exit 1
        fi

        declare ans_enable_dns=""

        while true; do
                echo -e "${C_WHITE}Do you want to link ${C_CYAN}\"/run/systemd/resolve/stub-resolv.conf\"${NO_FORMAT} to ${C_CYAN}\"/etc/resolv.conf\"${C_WHITE}? [Y/n] -> ${NO_FORMAT}\c"

                read ans_enable_dns
                : "${ans_enable_dns:=Y}"
                echo ""

                case "${ans_enable_dns}" in
                        [yY])
                                break
                                ;;
                        [nN])
                                echo -e "${C_YELLOW}Nothing has been done.${NO_FORMAT}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_YELLOW}Not a valid answer.${NO_FORMAT}\n"
                                ;;
                esac
        done

        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        if [[ -L "/etc/resolv.conf" ]]; then
                echo -e "${C_GREEN}The link has been created. ${C_WHITE}Exiting.${NO_FORMAT}"
        else
                echo -e "${C_RED}The link has not been created. An error occured. You may want to execute the command \"ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf\" manually. ${C_WHITE}Exiting.${NO_FORMAT}"
        fi
 
        return 0
}

main
