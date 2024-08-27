install_frw() {

        # Install nftables, but it should already be there
        echo -e "${C_WHITE}> ${INFO} Installing ${C_WHITE}nftables.${NO_FORMAT}"


        if systemctl status nftables 1> "/dev/null" 2>&1; then
                pacman -S nftables --noconfirm 1> /dev/null 2>&1
                if [[ "${?}" -eq 0 ]]; then
                        echo -e "${C_WHITE}> ${SUC} Installed ${C_WHITE}nftables.${NO_FORMAT}"
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} nftables.${NO_FORMAT}\n"
                        systemctl enable nftables 1> /dev/null 2>&1
                        if [[ "${?}" -ne 0 ]]; then
                                echo -e "${C_WHITE}> ${ERR} Cannot enable ${C_WHITE}nftables.${NO_FORMAT}\n"
                        fi
                else
                        echo -e "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}nftables.${NO_FORMAT}\n"
                fi
        fi

        # Install sshguard (fail2ban like)
        echo -e "${C_WHITE}> ${INFO} Installing ${C_WHITE}sshguard.${NO_FORMAT}"
        pacman -S sshguard --noconfirm 1> /dev/null 2>&1
        if [[ ! "${?}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}sshguard.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${SUC} Installed ${C_WHITE}sshguard.${NO_FORMAT}"
                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} sshguard.${NO_FORMAT}\n"
                systemctl enable sshguard 1> /dev/null 2>&1
        fi
}
