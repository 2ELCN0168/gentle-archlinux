#
### File: f_enable_network_manager.sh
#
### Description: 
# Enable network manager service.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - network-manager;
# - or systemd-networkd.
#
### Usage:
#
# 1. Enable the service.
#

enable_net_manager() {

        if [[ "${net_manager}" == "networkmanager" ]]; then
                printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} "
                printf "NetworkManager${N_F}.\n"

                if systemctl enable NetworkManager 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} ${C_W}NetworkManager "
                        printf "${C_G}enabled${C_W}.${N_F}\n\n"
                else
                        printf "${C_W}> ${WARN} ${C_W}NetworkManager "
                        printf "${C_R}could not be ${C_Y}enabled${C_W}."
                        printf "${N_F}\n\n"
                fi

        elif [[ "${net_manager}" == "systemd-networkd" ]]; then
                printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} "
                printf "systemd-networkd${N_F}.\n"

                if systemctl enable systemd-networkd 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} ${C_W}systemd-networkd "
                        printf "${C_G}enabled${C_W}.${N_F}\n\n"
                else
                        printf "${C_W}> ${WARN} ${C_W}systemd-networkd "
                        printf "${C_R}could not be ${C_Y}enabled${C_W}."
                        printf "${N_F}\n\n"
                fi
        fi
}
