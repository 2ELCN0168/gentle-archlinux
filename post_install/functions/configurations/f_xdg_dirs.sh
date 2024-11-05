#
### File: f_xdg_dirs.sh
#
### Description: 
# Create XDG user directories (Pictures, Documents, Videos, etc.)
#
### Author: 2ELCN0168
# Last updated: 2024-11-05
# 
### Dependencies:
# - xdg-user-dirs. 
#
### Usage:
#
# 1. Check if a user is created;
# 2. Ask the user what to do;
# 3. If Yes, create the directories.
#

create_xdg_dirs() {

        # INFO:
        # If no user is created, don't continue
        [[ "${createUser}" == "N" ]] && return

        while true; do
                printf "${C_C}:: ${C_W}Do you want to create regular user "
                printf "directories?\n"
                printf "${C_Y}(Documents, Pictures, Downloads, etc.)${N_F} "
                printf "[Y/n] -> "

                local ans_xdg_dirs
                read -r ans_xdg_dirs
                : "${ans_xdg_dirs:=Y}"
                printf "\n"

                if [[ "${ans_xdg_dirs}" =~ [yY] ]]; then
                        break
                elif [[ "${ans_xdg_dirs}" =~ [nN] ]]; then
                        return
                else
                        invalid_answer
                fi
        done

        # INFO:
        # Execute as the user created before
        if sudo --user="${username}" xdg-user-dirs-update \
        1> "/dev/null" 2>&1; then
                printf "${C_W}> ${INFO} User directories created for user "
                printf "${C_P}${username}${N_F}\n"
        else
                printf "${C_W}> ${WARN} Could not create user directories for "
                printf "user ${C_P}${username}${N_F}. Skipping...\n"
        fi

        printf "\n"
}
