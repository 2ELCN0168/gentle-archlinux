ask_newuser() {

        declare -g createUser=""

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Would you like to create a user? [y/N] ->${NO_FORMAT} \c"
                read createUser
                : "${createUser:=N}"
                echo ""

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

        declare -gx username=""
        declare sudo=""
        declare ans_username=""
        declare ans_sudoer=""

        while [[ -z "${username}" ]]; do
                echo -e "${C_CYAN}:: ${C_WHITE}What will be the name of the new user? ->${NO_FORMAT} \c"
                read ans_username
                username="${ans_username}"
                echo ""
        done

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Will this user be sudoer? [Y/n] ->${NO_FORMAT} \c"

                read ans_sudoer
                : "${ans_sudoer:=Y}"
                echo -e "\n"

                case "${ans_sudoer}" in
                        "y"|"Y")
                                sudo="-G wheel"
                                break
                                ;;
                        "n"|"N")
                                sudo=""
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating a new user named ${C_YELLOW}${username}${NO_FORMAT}.\n"

        declare -i i=""

        useradd -m -U ${sudo} -s "/bin/zsh" "${username}" 1> "/dev/null" 2>&1
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${SUC} ${NO_FORMAT}New user ${C_YELLOW}${username}${NO_FORMAT} created.\n"
                passwd "${username}"
                i=0
                echo ""
        else
                echo -e "${C_WHITE}> ${ERR} ${NO_FORMAT}New user ${C_YELLOW}${username}${NO_FORMAT} cannot be created.\n"
                i=1
        fi

        if [[ -z "${sudo}" && "${i}" -ne 1 ]]; then
                echo "${username} ALL=(ALL:ALL) ALL" > "/etc/sudoers.d/${username}"
        fi

        unset i
}
