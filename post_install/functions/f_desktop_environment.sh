#
### File: f_desktop_environment.sh
#
### Description: 
# Install a desktop environment.
# No window manager included.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - pacman;
# - git.
#
### Usage:
#
# 1. Download a window manager;
# 2. Installing a theme for sddm.
#

desktop_env() {

        local desktop_env=""

        while true; do
                printf "==${C_C}DESKTOP ENV.${N_F}======\n\n"

                printf "${C_W}[0] - ${C_C}GNOME${N_F}\n"
                printf "${C_W}[1] - ${C_C}KDE Plasma${N_F}\n"
                printf "${C_W}[2] - ${C_C}MATE${N_F}\n"
                printf "${C_W}[3] - ${C_C}Cinnamon${N_F}\n"
                printf "${C_W}[4] - ${C_C}LXDE${N_F}\n"
                printf "${C_W}[5] - ${C_C}MATE${N_F}\n"
                printf "${C_W}[6] - ${C_C}Xfce${N_F}\n"
                printf "${C_W}[7] - ${C_Y}None${N_F} (default)\n"

                printf "\n====================\n\n"
                
                printf "${C_C}${BOLD}:: ${C_W}Which one do you prefer? [0-7] "
                printf "-> ${N_F}"

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

        printf "${C_W}> ${INFO} Installing ${C_G}${desktop_env}${N_F}.\n"
        sleep 2

        if pacman -S --noconfirm "${desktop_env}"; then
                printf "\n${C_W}> ${SUC} Installed ${C_G}${desktop_env}"
                printf "${N_F}.\n"
        else
                printf "\n${C_W}> ${WARN} Cannot install ${C_G}${desktop_env}"
                printf "${N_F}.\n"
                return 1
        fi

        sleep 2

        printf "${C_W}> ${INFO} Installing ${C_C}sddm${N_F}.\n"
        if pacman -S --noconfirm sddm qt6-5compat qt6-declarative \
        qt6-svg alacritty; then
                printf "\n${C_W}> ${SUC} Installed ${C_G}sddm${N_F}.\n"

                printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                printf "${C_W} sddm.service .${N_F}\n"

                if systemctl enable "sddm.service" 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} ${C_G}Enabled "
                        printf "${C_Y}sddm.service${N_F}.\n\n"
                else
                        printf "${C_W}> ${WARN} ${C_R}Cannot enable "
                        printf "${C_Y}sddm.service${N_F}.\n\n"
                fi
        else
                printf "\n${C_W}> ${WARN} Cannot install ${C_G}sddm.${N_F}\n"
                return 1
        fi

        git clone "https://github.com/keyitdev/sddm-astronaut-theme.git" \
        "/usr/share/sddm/themes/sddm-astronaut-theme"

        cp -a "/usr/share/sddm/themes/sddm-astronaut-theme/Fonts/*" \
        "/usr/share/fonts/" 1> "/dev/null" 2>&1

        printf "[Theme]\n" > "/etc/sddm.conf"
        printf "Current=sddm-astronaut-theme\n" >> "/etc/sddm.conf"
        
        printf "\n"
}
