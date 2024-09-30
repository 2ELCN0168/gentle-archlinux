#
### File: f_genfstab.sh
#
### Description: 
# This function just generates the fstab file. 
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
#
### Dependencies:
# - arch-install-scripts (included in archiso).
#
### Usage:
#
# 1. Generate fstab file for everything mounted in "/mnt".
#
# NOTE:
# Long parameters for "genfstab" don't exist.
#

gen_fstab() {

        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Generating" \
                "${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
        # COMMAND:
        # genftab --uuid "/mnt"
        if genfstab -U "/mnt" >> "/mnt/etc/fstab"; then
                echo -e "${C_WHITE}> ${SUC} ${NO_FORMAT}Generated" \
                        "${C_PINK}/mnt/etc/fstab${NO_FORMAT} file.\n"
        else
                echo -e "${C_WHITE}> ${WARN} ${NO_FORMAT}Failed to generate" \
                        "${C_PINK}/mnt/etc/fstab${NO_FORMAT} file.\n"
        fi
}
