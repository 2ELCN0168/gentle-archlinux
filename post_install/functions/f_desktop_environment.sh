desktop_env() {

        local desktop_env=""

        while true; do
                echo -e "==${C_CYAN}DESKTOP ENV.${NO_FORMAT}======\n"

                echo -e "${C_WHITE}[0] - ${C_CYAN}GNOME${NO_FORMAT}"
                echo -e "${C_WHITE}[1] - ${C_CYAN}KDE Plasma${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_CYAN}MATE${NO_FORMAT}"
                echo -e "${C_WHITE}[3] - ${C_CYAN}Cinnamon${NO_FORMAT}"
                echo -e "${C_WHITE}[4] - ${C_CYAN}LXDE${NO_FORMAT}"
                echo -e "${C_WHITE}[5] - ${C_CYAN}MATE${NO_FORMAT}"
                echo -e "${C_WHITE}[6] - ${C_CYAN}Xfce${NO_FORMAT}"
                echo -e "${C_WHITE}[7] - ${C_YELLOW}None${NO_FORMAT} (default)"

                echo -e "\n====================\n"
                
                echo -e "${C_CYAN}${BOLD}:: ${C_WHITE}Which one do you prefer? [0-7] -> ${NO_FORMAT}\c"

                local ans_gui=""
                read ans_gui
                : "${ans_gui:=7}"

                case "${ans_gui}" in
                        [0])
                                desktop_env="gnome"
                                break
                                ;;
                        [1])
                                desktop_env="plasma"
                                break
                                ;;
                        [2])
                                desktop_env="mate"
                                break
                                ;;
                        [3])
                                desktop_env="cinnamon"
                                break
                                ;;
                        [4])
                                desktop_env="lxde"
                                break
                                ;;
                        [5])
                                desktop_env="mate"
                                break
                                ;;
                        [6])
                                desktop_env="xfce4"
                                break
                                ;;
                        [7])
                                return
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_WHITE}> ${INFO} Installing ${C_GREEN}${desktop_env}${NO_FORMAT}."
        pacman -S --noconfirm "${desktop_env}"

        if [[ "${?}" -ne 0 ]]; then
                echo -e "${C_WHITE}> ${ERR} Cannot install ${C_GREEN}${desktop_env}${NO_FORMAT}.\n"
        else
                echo -e "${C_WHITE}> ${SUC} Installed ${C_GREEN}${desktop_env}${NO_FORMAT}.\n"
        fi

        case "${desktop_env}" in
                "cinnamon"|"plasma"|"mate"|"xfce4")
                        pacman -S --noconfirm sddm qt6-5compat qt6-declarative qt6-svg
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} sddm.service .${NO_FORMAT}\n"
                        systemctl enable sddm.service 1> "/dev/null" 2>&1

                        if [[ "${?}" -ne 0 ]]; then
                                echo -e "${C_WHITE}> ${ERR} ${C_WHITE}Cannot enable ${C_YELLOW}sddm.service${NO_FORMAT}.\n"
                        fi
                        git clone "https://github.com/keyitdev/sddm-astronaut-theme.git" "/usr/share/sddm/themes/sddm-astronaut-theme"
                        cp "/usr/share/sddm/themes/sddm-astronaut-theme/Fonts/*" "/usr/share/fonts/"
                        echo "[Theme]
                              Current=sddm-astronaut-theme" | tee "/etc/sddm.conf"
                        ;;
                "gnome")
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} gdm.service .${NO_FORMAT}\n"
                        systemctl enable gdm.service 1> "/dev/null" 2>&1

                        if [[ "${?}" -ne 0 ]]; then
                                echo -e "${C_WHITE}> ${ERR} ${C_WHITE}Cannot enable ${C_YELLOW}gdm.service${NO_FORMAT}.\n"
                        fi
                        ;;
        esac

}
