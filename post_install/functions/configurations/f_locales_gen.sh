#
### File: f_locales_gen.sh
#
### Description: 
# Generates system locales.
#
### Author: 2ELCN0168
# Last updated: 2024-11-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Uncomment locales in /etc/locale.gen based on the timezone selected;
# 2. Generate locales.
#

locales_gen() {

        printf "${C_W}> ${INFO} ${N_F}Uncommenting ${C_C}en_US.UTF-8 UTF-8"
        printf "${N_F} in ${C_P}/etc/locale.gen${N_F}...\n"

        # INFO:
        # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
        sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' "/etc/locale.gen"

        case "${locales}" in
                "fr")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}fr_FR.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"
                        sed -i '/^\s*#\(fr_FR.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
                "gb")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}en_GB.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"

                        sed -i '/^\s*#\(en_GB.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
                "ja")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}ja_JP.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"

                        sed -i '/^\s*#\(ja_JP.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
                "ko")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}ko_KR.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"

                        sed -i '/^\s*#\(ko_KR.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
                "ru")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}ru_RU.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"

                        sed -i '/^\s*#\(ru_RU.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
                "zh")
                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}zh_HK.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n"

                        printf "${C_W}> ${INFO} ${N_F}Uncommenting "
                        printf "${C_C}zh_CN.UTF-8 UTF-8${N_F} "
                        printf "in ${C_P}/etc/locale.gen${N_F}...\n\n"

                        sed -i '/^\s*#\(zh_HK.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        sed -i '/^\s*#\(zh_CN.UTF-8 UTF-8\)/ s/^#//' \
                        "/etc/locale.gen"
                        ;;
        esac

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
