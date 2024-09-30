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

                echo -e "${C_CYAN}:: ${C_WHITE}Do you want your system to be" \
                        "encrypted with ${B_RED} LUKS ${NO_FORMAT} ? [y/N] -> \c"

                local ans_luks=""
                read ans_luks
                : "${ans_luks:=N}"

                case "${ans_luks}" in
                        [yY])
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}cryptsetup" \
                                        "${NO_FORMAT} will be installed.\n"
                                wantEncrypted=1
                                break
                                ;;
                        [nN])
                                echo -e "${C_WHITE}> ${INFO} ${C_RED}cryptsetup" \
                                        "${NO_FORMAT} won't be installed.\n"
                                wantEncrypted=0
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
