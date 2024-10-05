#
### File: f_locales_gen.sh
#
### Description: 
# Generates system locales.
#
### Author: 2ELCN0168
# Last updated: 2024-10-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Uncomment locale in /etc/locale.gen;
# 2. Generate locales.
#

locales_gen() {

        printf "${C_W}> ${INFO} ${N_F}Uncommenting ${C_C}en_US.UTF-8 UTF-8"
        printf "${N_F} in ${C_P}/etc/locale.gen${N_F}...\n\n"

        # INFO:
        # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
        sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' "/etc/locale.gen"

        printf "${C_W}> ${INFO} ${C_C}Generating locales...${N_F}\n"

        if locale-gen 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_G}Locales generated successfully."
                printf "${N_F}\n"
        else
                printf "${C_W}> ${WARN} ${C_Y}Failed to generate locales."
                printf "${N_F}\n"
        fi

        printf "\n"
}
