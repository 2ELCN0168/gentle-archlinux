#! /bin/bash

#
### File: 03_backup_luks_header.sh
#
### Description: 
# If the user is root, backup the LUKS header (and if LUKS is used obviously).
#
### Author: 2ELCN0168
# Last updated: 2024-11-08
# 
### Dependencies:
# - cryptsetup.
#
### Usage:
#
# 1. Check if the user is root;
# 2. Clone the paru repository;
# 3. Compile it.
#

main() {
        
        local C_R="\033[91m" # RED
        local C_G="\033[92m" # GREEN
        local C_C="\033[96m" # CYAN
        local C_Y="\033[93m" # YELLOW
        local C_W="\033[97m" # WHITE

        # End of the color sequence
        local N_F="\033[0m" # NO FORMAT

        if [[ "${EUID}" -ne 0  ]]; then
                printf "${C_W}:: ${C_R}This script must be executed as root. "
                printf "Exiting.${C_W} ::${N_F}\n"
                exit 1
        fi

        if ! hash cryptsetup; then
                printf "${C_W}:: ${C_R}cryptsetup is not installed. Exiting.\n"
                exit 1
        fi


        if ! lsblk -rno NAME,FSTYPE | awk '/crypto/ { print $1 }' \
        1> "/dev/null" 2>&1; then
                printf "${C_W}:: ${C_R}It seems that you have no disk using "
                printf "LUKS. Exiting.\n"
                exit 1
        fi

        local ans_luks_header=""

        while true; do
                printf "${C_W}Do you want to backup your partition luks "
                printf "header?\nIt's highly recommended to do so, in case "
                printf "the header become altered and your system becomes "
                printf "unusable. [Y/n] ->${N_F} "

                read ans_luks_header
                : "${ans_luks_header:=Y}"
                printf "\n"

                [[ "${ans_luks_header}" =~ ^[yYnN]$ ]] && break ||
                printf "${C_Y}Not a valid answer.${N_F}\n\n"
        done

        [[ "${ans_luks_header}" =~ [nN] ]] && \
        printf "${C_Y}Nothing has been done.${N_F}\n\n" && exit 0


        if cryptsetup luksHeaderBackup "/dev/$(lsblk -rno NAME,FSTYPE | 
        awk '/crypto/ { print $1 }')" --header-backup-file \
        "${HOME}/$(date +%Y%m%d)_luks_header_file.img"; then
                printf "File saved at ${C_G}${HOME}/"
                printf "$(date +%Y%m%d)_luks_header_file.img${N_F}\n"
        else
                printf "${C_R}Error during backup. Nothing has been done."
                printf "${N_F}\n"
        fi
}

main
