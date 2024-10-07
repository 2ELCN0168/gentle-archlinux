install_frw() {

        # NOTE:
        # Install nftables, but it should already be there
        
        printf "${C_W}> ${INFO} Installing ${C_W}nftables.${N_F}\n"

        if ! systemctl is-enabled nftables 1> "/dev/null" 2>&1; then
                if ! pacman -Qi nftables 1> "/dev/null" 2>&1; then
                        pacman -S nftables --noconfirm 1> "/dev/null" 2>&1
                        if [[ "${?}" -eq 0 ]]; then
                                echo -e "${C_W}> ${SUC} Installed ${C_W}nftables.${N_F}\n"
                        else
                                echo -e "${C_W}> ${ERR} Cannot install ${C_W}nftables.${N_F}\n"
                        fi
                fi

                echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} nftables.${N_F}"

                if systemctl enable nftables 1> "/dev/null" 2>&1; then
                        echo -e "${C_W}> ${SUC} nftables is ${C_G}enabled.${N_F}\n"
                else
                        echo -e "${C_W}> ${ERR} Cannot enable ${C_W}nftables.${N_F}\n"
                fi
        fi
                                
        # Install sshguard (fail2ban like)
        echo -e "${C_W}> ${INFO} Installing ${C_W}sshguard.${N_F}"

        if ! systemctl is-enabled sshguard 1> "/dev/null" 2>&1; then
                if ! pacman -Qi sshguard 1> "/dev/null" 2>&1; then
                        pacman -S sshguard --noconfirm 1> "/dev/null" 2>&1
                        if [[ "${?}" -eq 0 ]]; then
                                echo -e "${C_W}> ${SUC} Installed ${C_W}sshguard.${N_F}\n"
                        else
                                echo -e "${C_W}> ${ERR} Cannot install ${C_W}sshguard.${N_F}\n"
                        fi
                fi
                                
                echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} sshguard.${N_F}"

                if systemctl enable sshguard 1> "/dev/null" 2>&1; then
                        echo -e "${C_W}> ${SUC} sshguard is ${C_G}enabled.${N_F}\n"
                else
                        echo -e "${C_W}> ${ERR} Cannot enable ${C_W}sshguard.${N_F}\n"
                fi
        fi
}
