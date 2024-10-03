#
### File: f_mount_default.sh
#
### Description: 
# Ask the user which network manager they want to use.
#
### Author: 2ELCN0168
# Last updated: 2024-10-02
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

                if [[ "${param_minimal}" -eq 1 ]]; then
                        net_manager="networkmanager"
                        break
                fi

                net_menu                             

                local ans_net_manager=""
                read ans_net_manager
                : "${ans_net_manager:=0}"
                
                case "${ans_net_manager}" in
                        [0])
                                echo -e "${C_W}> ${INFO} You chose" \
                                        "${C_G}systemd-networkd${N_F}.\n"
                                net_manager="systemd-networkd"
                                break
                                ;;
                        [1])
                                echo -e "${C_W}> ${INFO} You chose" \
                                        "${C_C}NetworkManager${N_F}.\n"
                                net_manager="networkmanager" 
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

net_menu() {
        echo -e "\n==${C_C}NETWORK MANAGER${N_F}===\n"

        echo -e "${C_W}[0] - ${C_G}systemd-networkd${N_F} [default]"
        echo -e "${C_W}[1] - ${C_C}NetworkManager${N_F}"

        echo -e "\n====================\n"

        echo -e "${C_C}:: ${C_W}Which network manager do you want" \
                "to use? -> ${N_F}\c"
}
