net_manager() {
        export net_manager=""
        while true; do
                printf "==NETWORK MANAGER==="
                jump
                printf "${C_WHITE}[0] - ${C_GREEN}systemd-networkd${NO_FORMAT} [default]\n"
                printf "${C_WHITE}[1] - ${C_WHITE}NetworkManager${NO_FORMAT} \n"
                jump
                printf "====================\n"
                read -p "[?] - Which network manager do you want to use? " answer
                local answer=${answer:-"systemd-networkd"}
                printf "\n"
                case $answer in
                        0)
                                printf "${C_WHITE}> ${INFO}You chose ${C_GREEN}systemd-networkd${NO_FORMAT}."
                                net_manager="systemd-networkd"
                                break
                                ;;
                        1)
                                printf "${C_WHITE}> ${INFO}You chose ${C_CYAN}NetworkManager${NO_FORMAT}."
                                net_manager="networkmanager" 
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
