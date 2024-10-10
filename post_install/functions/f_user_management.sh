ask_newuser() {

        createUser=""

        while true; do
                printf "${C_C}:: ${C_W}Would you like to create a user? [y/N] "
                printf "-> ${N_F}"

                read createUser
                : "${createUser:=N}"
                printf "\n"

                if [[ "${createUser}" =~ [yY] ]]; then
                        create_user
                        break
                elif [[ "${createUser}" =~ [nN] ]]; then
                        printf "${C_W}> ${INFO} ${N_F}No user will be created."
                        printf "\n\n"
                        break
                else
                        invalid_answer
                fi
        done
}

create_user() {

        export username=""
        local sudo=""
        local ans_username=""
        local ans_sudoer=""
        printf "\n"

        while [[ -z "${username}" ]]; do
                printf "${C_C}:: ${C_W}What will be the name of the new user? "
                printf "-> ${N_F}"
                read ans_username
                username="${ans_username}"
                printf "\n"
        done

        while true; do
                printf "${C_C}:: ${C_W}Will this user be sudoer? [Y/n] "
                printf "-> ${N_F}"

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
