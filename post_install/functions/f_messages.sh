set_issue() {
        
        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Would you like to setup a /etc/issue file [Y/n] ->${NO_FORMAT} \c"

                local ans_issue=""
                read ans_issue
                : "${ans_issue:=Y}"
                echo ""

                case "${ans_issue}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} If you want to change it, edit the file /etc/issue after reboot.\n"
                                cp -a files/issue /etc/issue
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_WHITE}> ${INFO} No /etc/issue file will be created.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

set_motd() {
        
        echo -e "${C_CYAN}:: ${C_WHITE}Would you like to setup a /etc/motd file [Y/n] ->${NO_FORMAT} \c"

        local ans_motd=""
        read ans_motd
        : "${ans_motd:=Y}"
        echo ""

        while true; do
                case "${ans_motd}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} If you want to change it, edit the file /etc/motd after reboot.\n"
                                cp -a /files/motd /etc/motd
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_WHITE}> ${INFO} No /etc/motd file will be created.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
