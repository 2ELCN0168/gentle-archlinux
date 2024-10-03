desktop_env() {

        local desktop_env=""

        while true; do
                echo -e "==${C_C}DESKTOP ENV.${N_F}======\n"

                echo -e "${C_W}[0] - ${C_C}GNOME${N_F}"
                echo -e "${C_W}[1] - ${C_C}KDE Plasma${N_F}"
                echo -e "${C_W}[2] - ${C_C}MATE${N_F}"
                echo -e "${C_W}[3] - ${C_C}Cinnamon${N_F}"
                echo -e "${C_W}[4] - ${C_C}LXDE${N_F}"
                echo -e "${C_W}[5] - ${C_C}MATE${N_F}"
                echo -e "${C_W}[6] - ${C_C}Xfce${N_F}"
                echo -e "${C_W}[7] - ${C_Y}None${N_F} (default)"

                echo -e "\n====================\n"
                
                echo -e "${C_C}${BOLD}:: ${C_W}Which one do you prefer? [0-7] -> ${N_F}\c"

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

        echo -e "${C_W}> ${INFO} Installing ${C_G}${desktop_env}${N_F}."
        sleep 2
        pacman -S --noconfirm "${desktop_env}"

        if [[ "${?}" -ne 0 ]]; then
                echo -e "\n${C_W}> ${ERR} Cannot install ${C_G}${desktop_env}${N_F}.\n"
        else
                echo -e "\n${C_W}> ${SUC} Installed ${C_G}${desktop_env}${N_F}.\n"
        fi

        sleep 2

        case "${desktop_env}" in
                "cinnamon"|"plasma"|"mate"|"xfce4"|"gnome")
                        pacman -S --noconfirm sddm qt6-5compat qt6-declarative qt6-svg alacritty
                        echo -e "\n${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} sddm.service .${N_F}\n"
                        systemctl enable sddm.service 1> "/dev/null" 2>&1

                        if [[ "${?}" -ne 0 ]]; then
                                echo -e "${C_W}> ${ERR} ${C_W}Cannot enable ${C_Y}sddm.service${N_F}.\n"
                        fi
                        git clone "https://github.com/keyitdev/sddm-astronaut-theme.git" "/usr/share/sddm/themes/sddm-astronaut-theme"
                        cp -a "/usr/share/sddm/themes/sddm-astronaut-theme/Fonts/*" "/usr/share/fonts/" 1> "/dev/null" 2>&1
                        echo "[Theme]" >> "/etc/sddm.conf"
                        echo "Current=sddm-astronaut-theme" >> "/etc/sddm.conf"
                        ;;
                # "gnome")
                #         echo -e "\n${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} gdm.service .${N_F}\n"
                #         systemctl enable gdm.service 1> "/dev/null" 2>&1
                #
                #         if [[ "${?}" -ne 0 ]]; then
                #                 echo -e "${C_W}> ${ERR} ${C_W}Cannot enable ${C_Y}gdm.service${N_F}.\n"
                #         fi
                #         ;;
        esac

        echo ""
}
