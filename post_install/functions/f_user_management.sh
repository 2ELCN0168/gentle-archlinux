ask_newuser() {

        createUser=""

        while true; do

                # INFO:
                # If the root account is disabled, create a user account
                # without asking the user.
                [[ "${root_state}" -eq 0 ]] && break

                printf "${C_C}:: ${C_W}Would you like to create a user? "
                printf "[Y/n] -> ${N_F}" 

                read createUser
                : "${createUser:=Y}"
                printf "\n"

                if [[ "${createUser}" =~ [yY] ]]; then
                        break
                elif [[ "${createUser}" =~ [nN] ]]; then
                        printf "${C_W}> ${INFO} ${N_F}No user will be created."
                        printf "\n\n"
                        return
                else
                        invalid_answer
                fi
        done

        create_user
}

create_user() {

        export username=""
        local sudo=""
        local ans_username=""
        local ans_sudoer=""
        local usernames=(
                "anamorphic-whale"
                "outrageous-firefox"
                "fluffy-pancake"
                "vilain-giraffa"
                "metal-slime"
                "sweety-givrefoux"
                "theodoran-ax"
                "unstoppable-camera"
                "barking-windogs"
                "amazing-penguin"
                "magical-teapot"
        )

        local default_username=$(shuf -n 1 -e "${usernames[@]}")

        # REGEX:
        # Must start with a lowercase character or an underscore,
        # Hyphens and numbers are allowed after the first character.
        # Total length must not exceed 32 characters.
        local username_regex="^[a-z_][a-z0-9_-]{0,31}$"

        printf "${C_C}:: ${C_W}Enter your username.\n"
        printf "${C_C}:: ${C_W}Usernames must not exceed ${C_P}32 chars "
        printf "and they must only contain lowercase letters, digits, hyphens "
        printf "and underscores.\n"
        printf "${C_C}:: ${C_W}The first character must be a letter or an "
        printf "underscore.\n"
        printf "Default is ${C_B}'${default_username}'${N_F} -> "

        while true; do
                read ans_username
                username="${ans_username:=${default_username}}"
                printf "\n"

                if [[ "${ans_username}" =~ ${username_regex} ]]; then
                        printf "${C_W}> ${INFO} Username : "
                        printf "${C_P}${ans_username}${N_F}\n\n"
                        break
                else
                        printf "${C_W}> ${WARN} ${C_R} Invalid username.${N_F} "
                        printf "Usernames must be ${C_P} 1-32 characters long"
                        printf "${N_F}, containing only lowercase letters, "
                        printf "digits, hyphens or underscores.\n"
                        printf "The first character must be a lowercase letter."
                        printf "\n\n"

                        printf "${C_C}:: ${C_W}Please re-enter a valid "
                        printf "username -> ${N_F}"
                fi
        done

        while true; do
                printf "${C_C}:: ${C_W}Will this user be administrator? "
                printf "[Y/n] -> ${N_F}" 

                read ans_sudoer
                : "${ans_sudoer:=Y}"
                printf "\n"

                if [[ "${ans_sudoer}" =~ [yY] ]]; then
                        printf "${username} ALL=(ALL:ALL) ALL" \
                        1> "/etc/sudoers.d/${username}"
                        break
                elif [[ "${ans_sudoer}" =~ [nN] ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        printf "${C_W}> ${INFO} ${N_F}Creating a new user named "
        printf "${C_Y}${username}${N_F}.\n"


        if useradd -m -U -s "/bin/zsh" "${username}" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${N_F}New user ${C_Y}${username}${N_F} "
                printf "created.\n\n"
                passwd "${username}"
                printf "\n"
        else
                printf "${C_W}> ${ERR} ${N_F}New user ${C_Y}${username}${N_F} "
                printf "cannot be created.\n\n"
        fi
}
