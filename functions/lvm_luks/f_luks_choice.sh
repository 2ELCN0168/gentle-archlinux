#
### File: f_luks_choice.sh
#
### Description: 
# This function asks the user if they want to use LUKS to encrypt their filesystem.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - cryptsetup.
#
### Usage:
#
# 1. Don't encrypt if the parameter "minimal" is set;
# 2. Else, ask for LUKS.
#

luks_choice() {

        export wantEncrypted=0

        [[ "${param_minimal}" -eq 1 ]] && return

        while true; do

                printf "${C_C}:: ${C_W}Do you want your system to be "
                printf "encrypted with ${B_R} LUKS ${N_F} ? [y/N] -> "

                local ans_luks=""
                read ans_luks
                : "${ans_luks:=N}"

                if [[ "${ans_luks}" =~ [yY] ]]; then
                        wantEncrypted=1
                        printf "${C_W}> ${INFO} ${C_G}cryptsetup "
                        printf "${N_F} will be installed.\n\n"
                        break
                elif [[ "${ans_luks}" =~ [nN] ]]; then
                        wantEncrypted=0
                        printf "${C_W}> ${INFO} ${C_R}cryptsetup "
                        printf "${N_F} won't be installed.\n\n"
                        break
                else
                        invalid_answer
                fi
        done
}
