ask_newuser() {

        export createUser=""

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

                [[ "${createUser}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${createUser}" =~ ^[nN]$ ]]; then
                printf "${C_W}> ${INFO} No user will be created.\n\n"
                return
        fi
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
                "isometric-owl"
                "weird-canary"
                "cute-bacteria"
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
