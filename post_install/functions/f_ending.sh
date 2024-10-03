ending() {

        echo -e "${C_W}> ${SUC} ${C_G}Congratulations. The system has been installed.${N_F}\n"

        if fastfetch --version 1> "/dev/null" 2>&1; then
                if [[ "${nKorea}" -eq 1 ]]; then
                        fastfetch --logo redstar
                else
                        fastfetch
                fi
        fi

        if [[ "${createUser}" == [yY] ]]; then
                cp -a "/post_install/01_gentle-archlinux_post_installation_scripts" "/home/${username}"
                chown -R "${username}" "/home/${username}/01_gentle-archlinux_post_installation_scripts"
        else
                cp -a "/post_install/01_gentle-archlinux_post_installation_scripts" "/root"

        fi

        echo -e "${C_W}> ${INFO} ${C_W}You can now reboot to your new system or make adjustments to your liking.${N_F}\n"
        echo -e "${C_W}> ${INFO} ${C_W}Note: A set of post-installation scripts has been transferred to your home. You should see what's inside.${N_F}"
        echo -e "${C_W}Executing the DNS script is mandatory for it to work as it cannot be done during the system installation.\n" 

        echo -e "========================================================================================="
        echo -e "${C_W}::: ${C_B}Thank you for using my script! More can be found at ${C_C}https://github.com/2ELCN0168/${C_W} :::${N_F}"
        echo -e "========================================================================================="
        echo -e "${C_W}::: ${C_B}Feel free to contact me at ${C_C}lcn.en.perso@protonmail.com${C_W} :::${N_F}\n"

        echo -e "${C_W}>> [${C_C}END${C_W}] <<${N_F}\n"
}
