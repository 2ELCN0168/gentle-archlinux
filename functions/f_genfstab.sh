#
### File: f_genfstab.sh
#
### Description: 
# This function just generates the fstab file. 
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
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

        printf "${C_W}> ${INFO} ${N_F}Generating ${C_P}/mnt/etc/fstab${N_F} "
        printf "file.\n"

        # COMMAND:
        # genfstab --uuid "/mnt"
        if genfstab -U "/mnt" >> "/mnt/etc/fstab"; then
                printf "${C_W}> ${SUC} ${N_F}Generated ${C_P}/mnt/etc/fstab"
                printf "${N_F} file.\n\n"
        else
                printf "${C_W}> ${WARN} ${N_F}Failed to generate "
                printf "${C_P}/mnt/etc/fstab${N_F} file.\n\n"
        fi
}
