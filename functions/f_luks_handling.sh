#
### File: f_luks_handling.sh
#
### Description: 
# This function creates a LUKS format partition if the user answered "yes" to one of the first questions.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
#
### Dependencies:
# - cryptsetup.
#
### Usage:
#
# 1. Encrypt the root partition and replace the variable by its new location.
#

luks_handling() {

        echo -e "${C_W}> ${INFO} Starting to encrypt your new system...\n"

        if cryptsetup luksFormat "${root_part}"; then
                echo -e "\n${C_W}> ${SUC} ${C_G}Successfully created" \
                        "LUKS partition on ${root_part}.${N_F}\n"
        else
                echo -e "\n${C_W}> ${ERR} ${C_R}Error during LUKS" \
                        "partition creation on ${root_part}.${N_F}\n"
                exit 1
        fi

        echo -e "${C_W}> ${INFO} Opening the new encrypted volume.\n"

        cryptsetup open "${root_part}" "root" || exit 1

        echo -e "\n${C_W}> ${INFO} Replacing ${root_part} by${C_P}" \
                "/dev/mapper/root.${N_F}\n"

        root_part="/dev/mapper/root"
}
