#
### File: f_ending.sh
#
### Description: 
# This is the ending function with some informations on what to do next.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - none. 
#
### Usage:
#
# 1. Display the logo;
# 2. Move the post install scripts to the user directory;
# 3. Say bye-bye.
#

ending() {

        local path="/post_install/gentle-archlinux_misc_scripts"

        printf "${C_W}> ${SUC} ${C_G}Congratulations. The system has been "
        printf "installed.${N_F}\n\n"

        if fastfetch --version 1> "/dev/null" 2>&1; then
                if [[ "${nKorea}" -eq 1 ]]; then
                        fastfetch --logo redstar
                else
                        fastfetch
                fi
        fi

        if [[ "${createUser}" =~ [yY] ]]; then
                cp -a "${path}" "/home/${username}"
                chown -R "${username}:" \
                "/home/${username}/gentle-archlinux_misc_scripts"
        else
                cp -a "${path}" "/root"

        fi

        printf "${C_W}> ${INFO} ${C_W}You can now reboot to your new system or "
        printf "make adjustments to your liking.${N_F}\n\n"

        printf "${C_W}> ${INFO} ${C_W}Note: A set of post-installation scripts "
        printf "has been transferred to your home. You should see what's "
        printf "inside.${N_F}\n\n"

        printf "${C_R}Executing the DNS script is mandatory for it to work as "
        printf "it cannot be done during the system installation.${N_F}\n\n" 

        local sep="============================================"

        printf "${sep}${sep}\n"

        printf "${C_W}::: "

        printf "${C_B}Thank you for using my script! "
        printf "More can be found at ${C_C}https://github.com/2ELCN0168/${C_W} "

        printf ":::${N_F}\n"

        printf "${sep}${sep}\n"

        printf "${C_W}::: ${C_B}Feel free to contact me at "
        printf "${C_C}lcn.en.perso+github@protonmail.com${C_W} :::${N_F}\n\n"

        printf "${C_W}>> [${C_C}END${C_W}] <<${N_F}\n\n"
}
