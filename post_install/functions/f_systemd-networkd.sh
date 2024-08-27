systemd_networkd() {

        if [[ "${net_manager}" != "systemd-networkd" ]]; then
                return 1
        fi

        local network_interface=""

        while true; do
                echo -e "==INT. CONFIG.======\n"

                ip link show | grep -v "lo:" | awk -F ': ' '{ print $2 }'

                echo -e "====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE} Which interface do you want to configure with systemd-networkd? Type the name as you see it. ->${NO_FORMAT} \c"

                local ans_interface=""
                read ans_interface
                echo ""

                if [[ -d "/sys/class/net/${ans_interface}" ]]; then
                        network_interface="${ans_interface}"
                        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}The interface to configure is ${C_GREEN}${network_interface}${NO_FORMAT}\n"
                        break
                else
                        invalid_answer
                fi
        done

        cp "/post_install/files/systemd-networkd-template.conf" "/etc/systemd/network/05-${network_interface}.network"

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to configure your interface manually? If no, the DHCP option will be set. [y/N] ->${NO_FORMAT} \c"

                local ans_dhcp=""
                read ans_dhcp
                : "${ans_dhcp:=N}"
                echo ""

                case "${ans_dhcp}" in
                "y"|"Y")
                        echo -e "${C_WHITE}> ${INFO} The interface to configure is ${C_GREEN}${network_interface}${NO_FORMAT}\n"
                        break
                        ;;
                "n"|"N")
                       echo -e "${C_WHITE}> ${INFO} DHCP will be ${C_GREEN}enabled${NO_FORMAT}.\n"
                       sed -i "s/DHCP=/DHCP=yes/g" "/etc/systemd/network/05-${network_interface}.network"
                       return 0
                       ;;
                esac
        done

        local address=""
        local gateway=""

        echo -e "${C_CYAN}:: ${C_WHITE}What will be your IP address (IP/CIDR)? WARNING WHEN TYPING (e.g., 192.168.1.231/24) ->${NO_FORMAT} \c"
        read address
        echo -e "\n"

        echo -e "${C_CYAN}:: ${C_WHITE}What will be the gateway IP? WARNING WHEN TYPING (e.g., 192.168.1.1) ->${NO_FORMAT} \c"
        read gateway
        echo -e "\n"


        sed -i "s/name/${network_interface}/g" "/etc/systemd/network/05-${network_interface}.network"
        sed -i "s/domain/${domain}/g" "/etc/systemd/network/05-${network_interface}.network"
        sed -i "s/gateway/${gateway}/g" "/etc/systemd/network/05-${network_interface}.network"
        sed -i "s#ip#${address}#g" "/etc/systemd/network/05-${network_interface}.network"
}
