ending() {

        echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Congratulations. The system has been installed.${NO_FORMAT}\n"

        if fastfetch --version 1> /dev/null 2>&1; then
                if [[ "${nKorea}" -eq 1 ]]; then
                        fastfetch --logo redstar
                else
                        fastfetch
                fi
        fi

        if [[ "${createUser}" == [yY] ]]; then
                cp -a /post_install/01_gentle-archlinux_post_installation_scripts /home/"${username}"
                chown -R "${username}" /home/01_gentle-archlinux_post_installation_scripts
        else
                cp -a /post_install/01_gentle-archlinux_post_installation_scripts /root

        fi

        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}You can now reboot to your new system or make adjustments to your liking.${NO_FORMAT}\n"
        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Note: A set of post-installation scripts has been transferred to your home. You should see what's inside.${NO_FORMAT}"
        echo -e "${C_WHITE}Executing the DNS script is mandatory for it to work as it cannot be done during the system installation.\n" 

        echo -e "================================================================================================="
        echo -e "${C_WHITE}::: ${C_BLUE}Thank you for using my script! More can be found at ${C_CYAN}https://github.com/2ELCN0168/${C_WHITE} :::${NO_FORMAT}"
        echo -e "================================================================================================="
        echo -e "${C_WHITE}::: ${C_BLUE}Feel free to contact me at ${C_CYAN}lcn.en.perso@protonmail.com${C_WHITE} :::${NO_FORMAT}\n"

        echo -e "${C_WHITE}>> [${C_CYAN}END${C_WHITE}] <<${NO_FORMAT}\n"
}
