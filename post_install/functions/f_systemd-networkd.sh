systemd_networkd() {


        if [[ "${net_manager}" != "systemd-networkd" ]]; then
                return
        fi

        local network_interface=""
        local address=""
        local gateway=""

        while true; do
                echo -e "==${C_CYAN}INT. CONFIG.${NO_FORMAT}======\n"

                ls "/sys/class/net" | column -t | grep -v "lo"

                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE} Which interface do you want to configure with systemd-networkd? Type the name as you see it (default=ens18). -> ${NO_FORMAT}\c"

                local ans_interface=""
                read ans_interface
                : "${ans_interface:=ens18}"
                # echo ""

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
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to configure your interface manually? If no, the DHCP option will be set. [y/N] -> ${NO_FORMAT}\c"

                local ans_dhcp=""
                read ans_dhcp
                : "${ans_dhcp:=N}"
                # echo ""

                case "${ans_dhcp}" in
                "y"|"Y")
                        echo -e "${C_WHITE}> ${INFO} The interface to configure is ${C_GREEN}${network_interface}${NO_FORMAT}\n"

                        echo -e "${C_CYAN}:: ${C_WHITE}What will be your IP address (IP/CIDR)? WARNING WHEN TYPING (e.g., 192.168.1.231/24) -> ${NO_FORMAT}\c"
                        read address
                        echo -e "\n"

                        echo -e "${C_CYAN}:: ${C_WHITE}What will be the gateway IP? WARNING WHEN TYPING (e.g., 192.168.1.1) -> ${NO_FORMAT}\c"
                        read gateway
                        echo -e "\n"

                        break
                        ;;
                "n"|"N")
                       echo -e "${C_WHITE}> ${INFO} DHCP will be ${C_GREEN}enabled${NO_FORMAT}.\n"
                       # sed -i "s/DHCP=/DHCP=yes/g" "/etc/systemd/network/05-${network_interface}.network"
                       ;;
                esac
        done

        

        echo -e "${C_CYAN}:: ${C_WHITE}What will be your IP address (IP/CIDR)? WARNING WHEN TYPING (e.g., 192.168.1.231/24) -> ${NO_FORMAT}\c"
        read address
        echo -e "\n"

        echo -e "${C_CYAN}:: ${C_WHITE}What will be the gateway IP? WARNING WHEN TYPING (e.g., 192.168.1.1) -> ${NO_FORMAT}\c"
        read gateway
        echo -e "\n"


        # sed -i "s/name/${network_interface}/g" "/etc/systemd/network/05-${network_interface}.network"
        # sed -i "s/domain/${domain}/g" "/etc/systemd/network/05-${network_interface}.network"
        # sed -i "s/gateway/${gateway}/g" "/etc/systemd/network/05-${network_interface}.network"
        # sed -i "s#ip#${address}#g" "/etc/systemd/network/05-${network_interface}.network"

        # sed -i 's/^\(Name=\).*/\1${network_interface}/' "/etc/systemd/network/05-${network_interface}.network"
        # sed -i 's/^\(Domains=\).*/\1${domain}/'  "/etc/systemd/network/05-${network_interface}.network"
        # sed -i 's/^\(Gateway=\).*/\1${gateway}/' "/etc/systemd/network/05-${network_interface}.network"
        # sed -i 's#^\(Address=\).*#\1${address}#' "/etc/systemd/network/05-${network_interface}.network"
        
        cat << EOF > "/etc/systemd/network/05-${network_interface}.network"
        [Match]
        Name=${network_interface}

        [Network]
EOF

        if [[ "${ans_dhcp}" == [nN] ]]; then
                # sed -i 's/^\(DHCP=\).*/\1yes/' "/etc/systemd/network/05-${network_interface}.network" 
                cat << EOF > "/etc/systemd/network/05-${network_interface}.network"
                DHCP=yes
                Domains=${domain}
EOF
        else
                cat << EOF > "/etc/systemd/network/05-${network_interface}.network"
                DHCP=no
                Domains=${domain}

                Address=${address}
                Gateway=${gateway}
EOF
}
