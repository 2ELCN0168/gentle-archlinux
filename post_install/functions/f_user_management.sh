ask_newuser() {

        createUser=""

        while true; do
                echo -e "${C_C}:: ${C_W}Would you like to create a user? [y/N] -> ${N_F}\c"
                read createUser
                : "${createUser:=N}"
                # echo ""

                case "${createUser}" in
                        "y"|"Y")
                                create_user
                                #createUser="Y"
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_W}> ${INFO} ${N_F}No user will be created.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

create_user() {

        export username=""
        local sudo=""
        local ans_username=""
        local ans_sudoer=""
        echo ""

        while [[ -z "${username}" ]]; do
                echo -e "${C_C}:: ${C_W}What will be the name of the new user? -> ${N_F}\c"
                read ans_username
                username="${ans_username}"
                echo ""
        done

        while true; do
                echo -e "${C_C}:: ${C_W}Will this user be sudoer? [Y/n] -> ${N_F}\c"

                read ans_sudoer
                : "${ans_sudoer:=Y}"
                echo -e ""

                case "${ans_sudoer}" in
                        "y"|"Y")
                                echo "${username} ALL=(ALL:ALL) ALL" > "/etc/sudoers.d/${username}"
                                break
                                ;;
                        "n"|"N")
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_W}> ${INFO} ${N_F}Creating a new user named ${C_Y}${username}${N_F}."


        useradd -m -U -s "/bin/zsh" "${username}" 1> "/dev/null" 2>&1
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_W}> ${SUC} ${N_F}New user ${C_Y}${username}${N_F} created.\n"
                passwd "${username}"
                echo ""
        else
                echo -e "${C_W}> ${ERR} ${N_F}New user ${C_Y}${username}${N_F} cannot be created.\n"
                echo ""
        fi
}
