systemd_networkd() {


        if [[ "${net_manager}" != "systemd-networkd" ]]; then
                return
        fi

        local network_interface=""
        local address=""
        local gateway=""

        while true; do
                echo -e "==${C_C}INT. CONFIG.${N_F}======\n"

                ls "/sys/class/net" | column -t | grep -v "lo"

                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W} Which interface do you want to configure with systemd-networkd? Type the name as you see it (default=ens18). -> ${N_F}\c"

                local ans_interface=""
                read ans_interface
                : "${ans_interface:=ens18}"
                # echo ""

                if [[ -d "/sys/class/net/${ans_interface}" ]]; then
                        network_interface="${ans_interface}"
                        echo -e "${C_W}> ${INFO} ${N_F}The interface to configure is ${C_G}${network_interface}${N_F}\n"
                        break
                else
                        invalid_answer
                fi
        done

        cp "/post_install/files/systemd-networkd-template.conf" "/etc/systemd/network/05-${network_interface}.network"

        while true; do
                echo -e "${C_C}:: ${C_W}Do you want to configure your interface manually? If no, the DHCP option will be set. [y/N] -> ${N_F}\c"

                local ans_dhcp=""
                read ans_dhcp
                : "${ans_dhcp:=N}"
                # echo ""

                case "${ans_dhcp}" in
                "y"|"Y")
                        echo -e "${C_W}> ${INFO} The interface to configure is ${C_G}${network_interface}${N_F}\n"

                        echo -e "${C_C}:: ${C_W}What will be your IP address (IP/CIDR)? WARNING WHEN TYPING (e.g., 192.168.1.231/24) -> ${N_F}\c"
                        read address
                        echo -e "\n"

                        echo -e "${C_C}:: ${C_W}What will be the gateway IP? WARNING WHEN TYPING (e.g., 192.168.1.1) -> ${N_F}\c"
                        read gateway
                        echo -e "\n"

                        break
                        ;;
                "n"|"N")
                       echo -e "${C_W}> ${INFO} DHCP will be ${C_G}enabled${N_F}.\n"
                       # sed -i "s/DHCP=/DHCP=yes/g" "/etc/systemd/network/05-${network_interface}.network"
                       break
                       ;;
                esac
        done

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
        fi
}
