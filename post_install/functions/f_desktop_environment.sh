#
### File: f_desktop_environment.sh
#
### Description: 
# Install a desktop environment.
# No window manager included.
#
### Author: 2ELCN0168
# Last updated: 2024-11-11
# 
### Dependencies:
# - pacman;
# - git.
#
### Usage:
#
# 1. Download a window manager;
# 2. Installing a theme for sddm;
# 3. Revert to the network manager from the DE to avoid conflicts.
#

desktop_env() {

        local desktop_env=""

        while true; do

                print_box "Desktop Environment" "${C_C}" 40 

                printf "${C_W}[0] - ${C_C}GNOME${N_F}\n"
                printf "${C_W}[1] - ${C_C}KDE Plasma${N_F}\n"
                printf "${C_W}[2] - ${C_C}MATE${N_F}\n"
                printf "${C_W}[3] - ${C_C}Cinnamon${N_F}\n"
                printf "${C_W}[4] - ${C_C}LXDE${N_F}\n"
                printf "${C_W}[5] - ${C_C}MATE${N_F}\n"
                printf "${C_W}[6] - ${C_C}Xfce${N_F}\n"
                printf "${C_W}[7] - ${C_Y}None${N_F} (default)\n"

                printf "────────────────────────────────────────\n\n"
                
                printf "${C_C}${BOLD}:: ${C_W}Which one do you prefer? "
                printf "[0-7] -> ${N_F}"

                local ans_gui=""
                read ans_gui
                : "${ans_gui:=7}"

                [[ "${ans_gui}" =~ ^[0-7]$ ]] && break || invalid_answer
        done

        [[ "${ans_gui}" -ne 7 ]] && revert_net_manager

        case "${ans_gui}" in
                0) desktop_env="gnome" ;;
                1) desktop_env="plasma" ;;
                2) desktop_env="mate" ;;
                3) desktop_env="cinnamon" ;;
                4) desktop_env="lxde" ;;
                5) desktop_env="mate" ;;
                6) desktop_env="xfce4" ;;
                7) return ;;
        esac

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

        [[ "${desktop_env}" != "gnome" ]] && install_sddm && return

        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
        printf "${C_W} gdm.service .${N_F}\n"

        if systemctl enable "gdm.service" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_G}Enabled "
                printf "${C_Y}gdm.service${N_F}.\n\n"
        else
                printf "${C_W}> ${WARN} ${C_R}Cannot enable "
                printf "${C_Y}gdm.service${N_F}.\n\n"
        fi
}

install_sddm() {

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

revert_net_manager() {

        printf "${C_W}> ${INFO} ${C_W}The network manager you chose before may "
        printf "cause conflict with the one from the DE. Your choice will be "
        printf "discarded.${N_F}\n\n"

        # Defined in f_network_manager.sh
        net_manager=""
}
