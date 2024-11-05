systemd_networkd() {


        [[ "${net_manager}" != "systemd-networkd" ]] && return

        local network_interface=""
        local address=""
        local gateway=""

        while true; do

                print_box "Network interfaces" "${C_C}" 40 

                ls "/sys/class/net" | column -t | grep -v "lo"

                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W} Which interface do you want to "
                printf "configure with systemd-networkd? Type the name as you "
                printf "see it (default=ens18). -> ${N_F}"

                local ans_interface=""
                read ans_interface
                : "${ans_interface:=ens18}"

                if [[ -d "/sys/class/net/${ans_interface}" ]]; then
                        network_interface="${ans_interface}"
                        printf "${C_W}> ${INFO} ${N_F}The interface to "
                        printf "configure is ${C_G}${network_interface}"
                        printf "${N_F}\n\n"
                        break
                else
                        invalid_answer
                fi
        done

        while true; do
                printf "${C_C}:: ${C_W}Do you want to configure your interface "
                printf "manually? If no, the DHCP option will be set. "
                printf "[y/N] -> ${N_F}"

                local ans_dhcp=""
                read ans_dhcp
                : "${ans_dhcp:=N}"

                if [[ "${ans_dhcp}" =~ [yY] ]]; then
                        printf "${C_W}> ${INFO} The interface to configure is "
                        printf "${C_G}${network_interface}${N_F}\n\n"

                        printf "${C_C}:: ${C_W}What will be your IP address "
                        printf "(IP/CIDR)? WARNING WHEN TYPING "
                        printf "(e.g., 192.168.1.231/24) -> ${N_F}"
                        
                        read address
                        printf "\n\n"

                        printf "${C_C}:: ${C_W}What will be the gateway IP? "
                        printf "WARNING WHEN TYPING (e.g., 192.168.1.1) "
                        printf "-> ${N_F}"

                        read gateway
                        printf "\n"

                        break
                elif [[ "${ans_dhcp}" =~ [nN] ]]; then
                       printf "${C_W}> ${INFO} DHCP will be ${C_G}enabled"
                       printf "${N_F}.\n\n"
                       break
                else
                        invalid_answer
                fi
        done
        
        local if_path="/etc/systemd/network/05-${network_interface}.network"

        printf "[Match]\n" 1> "${if_path}"
        printf "Name=${network_interface}\n\n" 1>> "${if_path}"

        printf "[Network]\n" 1>> "${if_path}"

        if [[ "${ans_dhcp}" == [nN] ]]; then
                printf "DHCP=yes\n" 1>> "${if_path}"
                printf "Domains=${domain}\n" 1>> "${if_path}"
        else
                printf "DHCP=no\n" 1>> "${if_path}"
                printf "Domains=${domain}\n\n" 1>> "${if_path}"

                printf "Address=${address}\n" 1>> "${if_path}"
                printf "Gateway=${gateway}\n" 1>> "${if_path}"
        fi
}
