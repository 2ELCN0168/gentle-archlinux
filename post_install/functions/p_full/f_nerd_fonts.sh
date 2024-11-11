nerd_fonts() {

        local ans_gui=""
        while true; do
                printf "${C_C}:: ${C_W}Would you like to install nerd-fonts? "
                printf "[Y/n] -> ${N_F}"

                read ans_gui
                : "${ans_gui:=Y}"

                [[ "${ans_gui}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done
        
        [[ "${ans_gui}" =~ ^[nN]$ ]] && return

        printf "${C_W}> ${INFO} Installing nerd-fonts...\n"
        sleep 1

        if pacman -S --noconfirm nerd-fonts; then
                printf "\n"
                printf "${C_W}> ${SUC} nerd-fonts package has been installed "
                printf "${N_F}\n\n"
        else
                printf "\n"
                printf "${C_W}> ${ERR} nerd-fonts package could not be "
                printf "installed ${N_F}\n\n"
        fi
}
