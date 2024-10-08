ask_newuser() {

        createUser=""

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Would you like to create a user? [y/N] -> ${NO_FORMAT}\c"
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
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}No user will be created.\n"
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
                echo -e "${C_CYAN}:: ${C_WHITE}What will be the name of the new user? -> ${NO_FORMAT}\c"
                read ans_username
                username="${ans_username}"
                echo ""
        done

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Will this user be sudoer? [Y/n] -> ${NO_FORMAT}\c"

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

        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating a new user named ${C_YELLOW}${username}${NO_FORMAT}."


        useradd -m -U -s "/bin/zsh" "${username}" 1> "/dev/null" 2>&1
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${SUC} ${NO_FORMAT}New user ${C_YELLOW}${username}${NO_FORMAT} created.\n"
                passwd "${username}"
                echo ""
        else
                echo -e "${C_WHITE}> ${ERR} ${NO_FORMAT}New user ${C_YELLOW}${username}${NO_FORMAT} cannot be created.\n"
                echo ""
        fi
}
