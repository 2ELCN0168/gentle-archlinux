set_issue() {
        
        while true; do
                echo -e "${C_C}:: ${C_W}Would you like to setup a /etc/issue file [Y/n] -> ${N_F}\c"

                local ans_issue=""
                read ans_issue
                : "${ans_issue:=Y}"
                # echo ""

                case "${ans_issue}" in
                        "y"|"Y")
                                echo -e "${C_W}> ${INFO} If you want to change it, edit the file /etc/issue after reboot.\n"
                                cp -a "/post_install/files/issue" "/etc/issue" 1> "/dev/null" #2>&1
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_W}> ${INFO} No /etc/issue file will be created.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

set_motd() {
        
        echo -e "${C_C}:: ${C_W}Would you like to setup a /etc/motd file [Y/n] -> ${N_F}\c"

        local ans_motd=""
        read ans_motd
        : "${ans_motd:=Y}"
        # echo ""

        while true; do
                case "${ans_motd}" in
                        "y"|"Y")
                                echo -e "${C_W}> ${INFO} If you want to change it, edit the file /etc/motd after reboot.\n"
                                cp -a "/post_install/files/motd" "/etc/motd" 1> "/dev/null" #2>&1
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_W}> ${INFO} No /etc/motd file will be created.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
