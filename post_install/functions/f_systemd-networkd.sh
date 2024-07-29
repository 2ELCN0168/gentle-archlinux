systemd_networkd() {
       
       if [[ $net_manager == 'systemd-networkd' ]]; then
               local network_interface=
               while true; do
                       printf "==INT. CONFIG.======\n"
                       ip link show | grep -v "lo:" | awk -F ': ' '{ print $2 }'
                       printf "====================\n"

                       read -p "[?] - Which interface do you want to configure with systemd-networkd? Type full name. -> " response
                       local response=${response}
                       printf "\n"

                       if [ -z "${response}" ]; then
                       
                               invalid_answer
                       elif [ -d "/sys/class/net/${response}" ]; then
                               network_interface="${response}"
                               printf "\n"
                               printf "${C_WHITE}> ${INFO} ${NO_FORMAT}The interface to configure is ${C_GREEN}${network_interface}${NO_FORMAT}"
                               printf "\n"
                               break
                       else
                               printf "\n"
                               invalid_answer
                       fi
               done
               
               read -p "[?] - What will be your IP address (IP/CIDR)? WARNING WHEN TYPING (e.g., 192.168.1.231/24) " ip
               local address=${ip}
               printf "\n"

               read -p "[?] - What will be the gateway IP? WARNING WHEN TYPING (e.g., 192.168.1.1) " gateway 
               local gateway=${gateway}
               printf "\n"

               cp /post-install/files/systemd-networkd-template.conf /etc/systemd/network/05-${network_interface}.network
               chmod 644 /etc/systemd/network/*

               sed -i "s/name/${network_interface}" /etc/systemd/network/05-${network_interface}.network
               sed -i "s/domain/${domain}" /etc/systemd/network/05-${network_interface}.network
               sed -i "s/gateway/${gateway}" /etc/systemd/network/05-${network_interface}.network
               sed -i "s/address/${address}" /etc/systemd/network/05-${network_interface}.network
       fi
}
