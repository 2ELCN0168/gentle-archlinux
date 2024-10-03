#! /bin/bash

declare C_R="\033[91m"
declare C_G="\033[92m"
declare C_C="\033[96m"
declare C_Y="\033[93m"
declare C_W="\033[97m"

# End of the color sequence
declare N_F="\033[0m"

main() {

        if [[ "${EUID}" -ne 0 ]]; then
                echo -e "${C_W}:: ${C_R}This script must be executed as root. Exiting.${C_W} ::${N_F}"
                exit 1
        fi

        declare ans_enable_dns=""

        while true; do
                echo -e "${C_W}Do you want to link ${C_C}\"/run/systemd/resolve/stub-resolv.conf\"${N_F} to ${C_C}\"/etc/resolv.conf\"${C_W}? [Y/n] -> ${N_F}\c"

                read ans_enable_dns
                : "${ans_enable_dns:=Y}"
                echo ""

                case "${ans_enable_dns}" in
                        [yY])
                                break
                                ;;
                        [nN])
                                echo -e "${C_Y}Nothing has been done.${N_F}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_Y}Not a valid answer.${N_F}\n"
                                ;;
                esac
        done

        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        if [[ -L "/etc/resolv.conf" ]]; then
                echo -e "${C_G}The link has been created. ${C_W}Exiting.${N_F}"
        else
                echo -e "${C_R}The link has not been created. An error occured. You may want to execute the command \"ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf\" manually. ${C_W}Exiting.${N_F}"
        fi
 
        return 0
}

main
