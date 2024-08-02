# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

net_manager() {

        declare -gx net_manager=""

        while true; do
                echo -e "\n==NETWORK MANAGER===\n"

                echo -e "${C_WHITE}[0] - ${C_GREEN}systemd-networkd${NO_FORMAT} [default]"
                echo -e "${C_WHITE}[1] - ${C_WHITE}NetworkManager${NO_FORMAT}"

                echo -e "\n====================\n"

                echo -e "${B_CYAN} [?] - Which network manager do you want to use? -> ${NO_FORMAT} \c"
                
                declare -i ans_net_manager=""
                read ans_net_manager
                : "${ans_net_manager:=0}"
                echo ""
                
                case "${ans_net_manager}" in
                        [0])
                                echo -e "${C_WHITE}> ${INFO} You chose ${C_GREEN}systemd-networkd${NO_FORMAT}.\n"
                                net_manager="systemd-networkd"
                                break
                                ;;
                        [1])
                                echo -e "${C_WHITE}> ${INFO} You chose ${C_CYAN}NetworkManager${NO_FORMAT}.\n"
                                net_manager="networkmanager" 
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
