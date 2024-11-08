set_issue() {
        
        while true; do
                printf "${C_C}:: ${C_W}Would you like to setup a /etc/issue "
                printf "file [Y/n] -> ${N_F}"

                local ans_issue=""
                read ans_issue
                : "${ans_issue:=Y}"

                [[ "${ans_issue}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans_issue}" =~ ^[yY]$ ]]; then
                printf "${C_W}> ${INFO} If you want to change it, edit "
                printf "the file ${C_P}/etc/issue${N_F} after reboot."
                printf "\n\n"
                cp -a "/post_install/files/issue" "/etc/issue" \
                1> "/dev/null" 2>&1
        elif [[ "${ans_issue}" =~ ^[nN]$ ]]; then
                printf "${C_W}> ${INFO} No /etc/issue file will be "
                printf "created.\n\n"
        fi
}

set_motd() {
        
        

        while true; do
                printf "${C_C}:: ${C_W}Would you like to setup a /etc/motd "
                printf "file [Y/n] -> ${N_F}"

                local ans_motd=""
                read ans_motd
                : "${ans_motd:=Y}"

                [[ "${ans_motd}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans_motd}" =~ ^[yY]$ ]]; then
                printf "${C_W}> ${INFO} If you want to change it, edit "
                printf "the file ${C_P}/etc/motd${N_F} after reboot."
                printf "\n\n"
                cp -a "/post_install/files/motd" "/etc/motd" \
                1> "/dev/null" 2>&1
        elif [[ "${ans_motd}" =~ ^[nN]$ ]]; then
                printf "${C_W}> ${INFO} No /etc/motd file will be "
                printf "created.\n\n"
        fi
}
