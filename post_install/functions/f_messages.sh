messages() {
        set_issue
        set_motd
}


set_issue() {
        
        read -p "[?] - Would you like to setup a /etc/issue file? [Y/n] " response
        local response=${response:-Y}
        while true; do
                printf "\n"
                case "$response" in
                        [yY])
                                printf "${C_WHITE}> ${INFO}Type the message you want to be displayed before logging in: "
                                printf "\n"
                                read -p "" issue
                                local issue="${issue}"
                                cat "${issue}" > /etc/issue
                                jump
                                break
                                ;;
                        [nN])
                                printf "${C_WHITE}> ${INFO}No /etc/issue file will be created."
                                jump
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

set_motd() {
        
        read -p "[?] - Would you like to setup a /etc/motd file? [Y/n] " response
        local response=${response:-Y}
        while true; do
                case "$response" in
                        [yY])
                                printf "${C_WHITE}> ${INFO}Type the message you want to be displayed after logging in: "
                                printf "\n"
                                read -p "" motd
                                local motd="${motd}"
                                cat "${motd}" > /etc/motd
                                jump
                                break
                                ;;
                        [nN])
                                printf "${C_WHITE}> ${INFO}No /etc/motd file will be created."
                                jump
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
