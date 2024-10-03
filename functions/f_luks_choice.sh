#
### File: f_luks_choice.sh
#
### Description: 
# This function asks the user if they want to use LUKS to encrypt their filesystem.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
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

                echo -e "${C_C}:: ${C_W}Do you want your system to be" \
                        "encrypted with ${B_R} LUKS ${N_F} ? [y/N] -> \c"

                local ans_luks=""
                read ans_luks
                : "${ans_luks:=N}"

                case "${ans_luks}" in
                        [yY])
                                echo -e "${C_W}> ${INFO} ${C_G}cryptsetup" \
                                        "${N_F} will be installed.\n"
                                wantEncrypted=1
                                break
                                ;;
                        [nN])
                                echo -e "${C_W}> ${INFO} ${C_R}cryptsetup" \
                                        "${N_F} won't be installed.\n"
                                wantEncrypted=0
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
