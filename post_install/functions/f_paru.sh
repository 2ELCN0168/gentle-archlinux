install_paru() {

        while true; do

                declare -i testMem=$(free -m | head -2 | tail -1 | awk '{print $2}')

                if [[ "${testMem}" -lt 7000 && "${createUser}" == [Nn] ]]; then
                        break
                fi
                echo -e "${C_CYAN}:: ${C_WHITE}Would you like to install paru? It's an AUR helper like yay. [y/N]"
                echo -e "${C_CYAN}:: ${C_WHITE}Warning, this can take some time...${NO_FORMAT} \c"

                declare ans_paru=""
                read ans_paru
                : "${ans_paru:=N}"
                echo ""

                case "${ans_paru}" in 
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Installing ${C_CYAN}paru${NO_FORMAT}..."
                                git clone https://aur.archlinux.org/paru.git /home/"${username}"/paru
                                pacman -S --noconfirm rust 1> /dev/null 2>&1
                                cd /home/"${username}"/
                                echo "#! /bin/bash" > /home/"${username}"/paru/mpg.sh
                                echo "makepkg -si" >> /home/"${username}"/paru/mpg.sh
                                chown -R "${username}": paru
                                cd paru
                                su "${username}" -c ./mpg.sh
                                rm -f mpg.sh
                                mv -r /home/$username/paru /usr/src

                                if paru --version; then
                                  echo -e "${C_WHITE}> ${SUC} ${C_WHITE}${C_CYAN}paru${NO_FORMAT} successfully installed."
                                else
                                  echo -e "${C_WHITE}> ${ERR} ${C_WHITE}Cannot install ${C_CYAN}paru${NO_FORMAT}."
                                fi
                                ;;
                        "n"|"N")
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
