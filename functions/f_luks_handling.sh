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

        echo -e "${C_WHITE}> ${INFO} Starting to encrypt your new system...\n"

        if cryptsetup luksFormat "${root_part}"; then
                echo -e "\n${C_WHITE}> ${SUC} ${C_GREEN}Successfully created" \
                        "LUKS partition on ${root_part}.${NO_FORMAT}\n"
        else
                echo -e "\n${C_WHITE}> ${ERR} ${C_RED}Error during LUKS" \
                        "partition creation on ${root_part}.${NO_FORMAT}\n"
                exit 1
        fi

        echo -e "${C_WHITE}> ${INFO} Opening the new encrypted volume.\n"

        cryptsetup open "${root_part}" "root" || exit 1

        echo -e "\n${C_WHITE}> ${INFO} Replacing ${root_part} by${C_PINK}" \
                "/dev/mapper/root.${NO_FORMAT}\n"

        root_part="/dev/mapper/root"
}
