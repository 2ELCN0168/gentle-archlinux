#! /bin/bash

#
### File: 01_enable_dns.sh
#
### Description: 
# Link /run/systemd/resolve/stub-resolv.conf to /etc/resolv.conf to
# enable systemd-resolved correctly. This cannot be done during the installation
# process.
#
### Author: 2ELCN0168
# Last updated: 2024-11-08
# 
### Dependencies:
# - systemd-resolved.
#
### Usage:
#
# 1. Ask the user what they want to do;
# 2. If "yes": link the file.
#

main() {

        local C_R="\033[91m" # RED
        local C_G="\033[92m" # GREEN
        local C_C="\033[96m" # CYAN
        local C_Y="\033[93m" # YELLOW
        local C_W="\033[97m" # WHITE

        # End of the color sequence
        local N_F="\033[0m" # NO FORMAT


        if [[ "${EUID}" -ne 0 ]]; then
                printf "${C_W}:: ${C_R}This script must be executed as root. "
                printf "Exiting.${C_W} ::${N_F}\n"
                exit 1
        fi

        local ans_enable_dns=""

        while true; do
                printf "${C_W}Do you want to link ${C_C}\"/run/systemd/"
                printf "resolve/stub-resolv.conf\"${N_F} to ${C_C}\"/etc/"
                printf "resolv.conf\"${C_W}? [Y/n] -> ${N_F}"

                read ans_enable_dns
                : "${ans_enable_dns:=Y}"
                printf "\n"

                [[ "${ans_enable_dns}" =~ ^[yYnN]$ ]] && break ||
                printf "${C_Y}Not a valid answer.${N_F}\n\n"
        done

        [[ "${ans_enable_dns}" =~ [nN] ]] && \
        printf "${C_Y}Nothing has been done.${N_F}\n\n" && exit 0

        if ln -sf "/run/systemd/resolve/stub-resolv.conf" \
        "/etc/resolv.conf"; then
                printf "${C_G}The link has been created. ${C_W}Exiting.${N_F}"
                printf "\n\n"
        else
                printf "${C_R}The link has not been created. An error occured. "
                printf "You may want to execute the command \"ln -sf "
                printf "/run/systemd/resolve/stub-resolv.conf "
                printf "/etc/resolv.conf\" manually. ${C_W}Exiting.${N_F}\n\n"
        fi
}

main
