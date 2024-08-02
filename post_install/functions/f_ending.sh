ending() {

        echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Congratulations. The system has been installed.${NO_FORMAT}\n"

        if fastfetch --version 1> /dev/null 2>&1; then
                if [[ "${nKorea}" -eq 1 ]]; then
                        fastfetch --logo redstar
                else
                        fastfetch
                fi
        fi

        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}You can now reboot to your new system or make adjustments to your liking.${NO_FORMAT}\n"

        echo -e "${C_WHITE}>> [${C_CYAN}END${C_WHITE}] <<${NO_FORMAT}\n"
}
