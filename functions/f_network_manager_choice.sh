#
### File: f_mount_default.sh
#
### Description: 
# Ask the user which network manager they want to use.
#
### Author: 2ELCN0168
# Last updated: 2024-11-07
#
### Dependencies:
# - network-manager (indirectly); 
# - systemd-networkd (indirectly);
#
### Usage:
#
# 1. It is a simple question/answer.
#

net_manager() {

        export net_manager=""

        while true; do

                [[ "${param_minimal}" -eq 1 ]] && \
                net_manager="networkmanager" && break

                net_menu                             

                local ans_net_manager=""
                read -r ans_net_manager
                : "${ans_net_manager:=0}"

                [[ "${ans_net_manager}" =~ ^[012]$ ]] && break
        done

        if [[ "${ans_net_manager}" -eq 0 ]]; then
                printf "${C_W}> ${INFO} You chose "
                printf "${C_G}systemd-networkd${N_F}.\n\n"
                net_manager="systemd-networkd"
        elif [[ "${ans_net_manager}" -eq 1 ]]; then
                printf "${C_W}> ${INFO} You chose "
                printf "${C_C}NetworkManager${N_F}.\n\n"
                net_manager="networkmanager" 
        elif [[ "${ans_net_manager}" -eq 2 ]]; then
                return
        else
                invalid_answer
        fi
}

net_menu() {

        print_box "Network Manager" "${C_C}" 40 

        printf "${C_W}[0] - ${C_G}systemd-networkd${N_F} [default]\n"
        printf "${C_W}[1] - ${C_C}NetworkManager${N_F}\n"
        printf "${C_Y}[2] - Skip ->${N_F}\n\n"

        printf "────────────────────────────────────────\n\n"

        printf "${C_C}:: ${C_W}Which network manager do you want to use? -> "
        printf "${N_F}"
}
