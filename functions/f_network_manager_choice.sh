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
                                echo -e "${C_WHITE}> ${INFO} You chose" \
                                        "${C_GREEN}systemd-networkd${NO_FORMAT}.\n"
                                net_manager="systemd-networkd"
                                break
                                ;;
                        [1])
                                echo -e "${C_WHITE}> ${INFO} You chose" \
                                        "${C_CYAN}NetworkManager${NO_FORMAT}.\n"
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
        echo -e "\n==${C_CYAN}NETWORK MANAGER${NO_FORMAT}===\n"

        echo -e "${C_WHITE}[0] - ${C_GREEN}systemd-networkd${NO_FORMAT} [default]"
        echo -e "${C_WHITE}[1] - ${C_CYAN}NetworkManager${NO_FORMAT}"

        echo -e "\n====================\n"

        echo -e "${C_CYAN}:: ${C_WHITE}Which network manager do you want" \
                "to use? -> ${NO_FORMAT}\c"
}
