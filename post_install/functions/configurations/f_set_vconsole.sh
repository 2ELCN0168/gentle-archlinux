#
### File: f_set_vconsole.sh
#
### Description: 
# Set the vconsole.conf file in /etc.
#
### Author: 2ELCN0168
# Last updated: 2024-10-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Set the keymap and font for TTY.
#

set_vconsole() {

        printf "${C_W}> ${INFO} ${N_F}Creating the file ${C_P}"
        printf "/etc/vconsole.conf${N_F}.\n"

        local keymap=""

        while true; do
                printf "\n==${C_C}KEYMAP${N_F}============\n\n"

                printf "${C_W}[0] - ${C_B}US INTL. - QWERTY${N_F} [default]\n"
                printf "${C_W}[1] - ${C_B}US - QWERTY${N_F}\n"
                printf "${C_W}[2] - ${C_C}FR - AZERTY${N_F}\n"
                
                printf "\n====================\n\n"

                printf "${C_C}:: ${C_W}Select your keymap -> ${N_F}"

                local ans_keymap=""
                read ans_keymap
                : "${ans_keymap:=0}"
                printf "\n"

                [[ "${ans_keymap}" == "0" ]] && keymap="us-acentos" && break
                [[ "${ans_keymap}" == "1" ]] && keymap="us" && break
                [[ "${ans_keymap}" == "2" ]] && keymap="fr" && break

                invalid_answer
        done

        printf "${C_W}> ${INFO} ${N_F}You chose ${C_P}${keymap}${N_F}.\n\n"

        echo "KEYMAP=${keymap}" 1> "/etc/vconsole.conf"
        echo "FONT=ter-116b" 1>> "/etc/vconsole.conf"
}
