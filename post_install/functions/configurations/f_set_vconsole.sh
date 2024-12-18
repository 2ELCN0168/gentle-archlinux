#
### File: f_set_vconsole.sh
#
### Description: 
# Set the vconsole.conf file in /etc.
#
### Author: 2ELCN0168
# Last updated: 2024-11-08
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

                print_box "Keymap" "${C_C}" 40 

                printf "${C_W}[0] - ${C_B}US INTL. - QWERTY with dead keys"
                printf "${N_F} [default]\n"
                printf "${C_W}[1] - ${C_B}US - QWERTY${N_F}\n"
                printf "${C_W}[2] - ${C_C}FR - AZERTY${N_F}\n\n"
                
                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W}Select your keymap -> ${N_F}"

                local ans_keymap=""
                read ans_keymap
                : "${ans_keymap:=0}"
                printf "\n"

                [[ "${ans_keymap}" =~ ^[0-2]$ ]] && break || invalid_answer
        done

        case "${ans_keymap}" in
                0) keymap="us-acentos" ;;
                1) keymap="us" ;;
                2) keymap="fr" ;;
        esac

        printf "${C_W}> ${INFO} ${N_F}You chose ${C_P}${keymap}${N_F}.\n\n"

        echo "KEYMAP=${keymap}" 1> "/etc/vconsole.conf"
        echo "FONT=ter-116b" 1>> "/etc/vconsole.conf"
}
