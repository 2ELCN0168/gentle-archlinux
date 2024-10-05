#
### File: f_luks_handling.sh
#
### Description: 
# This function creates a LUKS format partition if the user answered "yes" to one of the first questions.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - cryptsetup.
#
### Usage:
#
# 1. Encrypt the root partition and replace the variable by its new location.
#

luks_handling() {

        printf "${C_W}> ${INFO} Starting to encrypt your new system...\n\n"

        if cryptsetup luksFormat "${root_part}"; then
                printf "\n${C_W}> ${SUC} ${C_G}Successfully created "
                printf "LUKS partition on ${root_part}.${N_F}\n\n"
        else
                printf "\n${C_W}> ${ERR} ${C_R}Error during LUKS "
                printf "partition creation on ${root_part}.${N_F}\n\n"
                exit 1
        fi

        printf "${C_W}> ${INFO} Opening the new encrypted volume.\n\n"

        if cryptsetup open "${root_part}" "root"; then
                printf "\n${C_W}> ${INFO} Replacing ${root_part} by${C_P} "
                printf "/dev/mapper/root.${N_F}\n\n"
                root_part="/dev/mapper/root"
                return
        else
                exit 1
        fi
}
