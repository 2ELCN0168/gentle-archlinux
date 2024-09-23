install_frw() {

        # NEED TO BE REDONE 
        #
        # Install nftables, but it should already be there
        echo -e "${C_WHITE}> ${INFO} Installing ${C_WHITE}nftables.${NO_FORMAT}"

        if ! systemctl is-enabled nftables; then
                if ! pacman -Qi nftables; then
                        pacman -S nftables --noconfirm
                        if [[ "${?}" -eq 0 ]]; then
                                echo -e "${C_WHITE}> ${SUC} Installed ${C_WHITE}nftables.${NO_FORMAT}\n"
                        else
                                echo -e "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}nftables.${NO_FORMAT}\n"
                        fi
                fi

                if systemctl enable nftables 1> "/dev/null" 2>&1; then
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} nftables.${NO_FORMAT}\n"
                else
                        echo -e "${C_WHITE}> ${ERR} Cannot enable ${C_WHITE}nftables.${NO_FORMAT}\n"
                fi
                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}nftables is already ${C_GREEN}enabled.${NO_FORMAT}\n"
        fi
                                
        # Install sshguard (fail2ban like)
        echo -e "${C_WHITE}> ${INFO} Installing ${C_WHITE}sshguard.${NO_FORMAT}"

        if ! systemctl is-enabled sshguard #1> "/dev/null" 2>&1
                then
                if ! pacman -Qi sshguard # 1> "/dev/null" 2>&1; 
                then
                        pacman -S sshguard --noconfirm #1> "/dev/null" 2>&1
                        if [[ "${?}" -eq 0 ]]; then
                                echo -e "${C_WHITE}> ${SUC} Installed ${C_WHITE}sshguard.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}sshguard.${NO_FORMAT}\n"
                        fi
                fi
                                
                if systemctl enable sshguard 1> "/dev/null" 2>&1; then
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} sshguard.${NO_FORMAT}\n"
                else
                        echo -e "${C_WHITE}> ${ERR} Cannot enable ${C_WHITE}sshguard.${NO_FORMAT}\n"
                fi
        fi
}
