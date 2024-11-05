create_themes() {

        export theme_brightness=-1

        while true; do

                print_box "Themes" "${C_C}" 40 

                printf "${C_W}[0] - ${C_W}Catppuccin latte (light)${N_F}\n"
                printf "${C_W}[1] - ${C_C}Tokyonight storm (dark)${N_F} "
                printf "[default]\n"
                printf "${C_W}[2] - ${C_R}Red impact (dark)${N_F}\n"
                printf "${C_W}[3] - ${C_P}Dracula (dark)${N_F}\n"
                printf "${C_W}[4] - ${C_Y}Mono Amber (dark)${N_F}\n"
                printf "${C_W}[5] - ${C_G}Mono Green (dark)${N_F}\n"
                printf "${C_W}[6] - ${C_B}Powershell (medium)${N_F}\n"
                printf "${C_W}[7] - ${C_Y}Ryuuko (medium)${N_F}\n"
                printf "${C_W}[8] - ${C_Y}Batman (medium)${N_F}\n"
                printf "${C_W}[9] - ${N_F}Keep default TTY colors\n\n"

                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W}Which theme do you prefer for your TTY? "
                printf "Each one will be created anyway. -> ${N_F}"

                local tty_theme=""
                local ans_tty_theme=""
                local path=""
                read ans_tty_theme
                : "${ans_tty_theme:=1}"

                case "${ans_tty_theme}" in
                        [0])
                                tty_theme="Catppuccin latte"
                                path="/etc/tty_themes.d/catppuccin_latte.sh"
                                theme_brightness=1
                                break
                                ;;
                        [1])
                                tty_theme="Tokyonight Storm"
                                path="/etc/tty_themes.d/tokyonight_storm.sh"
                                theme_brightness=0
                                break
                                ;;
                        [2])
                                tty_theme="Red impact"
                                path="/etc/tty_themes.d/red_impact.sh"
                                theme_brightness=0
                                break
                                ;;
                        [3])
                                tty_theme="Dracula"
                                path="/etc/tty_themes.d/dracula.sh"
                                theme_brightness=0
                                break
                                ;;
                        [4])
                                tty_theme="Mono Amber"
                                path="/etc/tty_themes.d/mono_amber.sh"
                                theme_brightness=0
                                break
                                ;;
                        [5])
                                tty_theme="Mono Green"
                                path="/etc/tty_themes.d/mono_green.sh"
                                theme_brightness=0
                                break
                                ;;
                        [6])
                                tty_theme="Powershell"
                                path="/etc/tty_themes.d/powershell.sh"
                                theme_brightness=0
                                break
                                ;;
                        [7])
                                tty_theme="Ryuuko"
                                path="/etc/tty_themes.d/ryuuko.sh"
                                theme_brightness=0
                                break
                                ;;
                        [8])
                                tty_theme="Batman"
                                path="/etc/tty_themes.d/batman.sh"
                                theme_brightness=0
                                break
                                ;;
                        [9])
                                tty_theme="Default"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
        
        if [[ "${tty_theme}" != "Default" ]]; then
                echo "source ${path}" 1>> "/etc/skel/.bashrc" \
                1>> "/etc/skel/.zshrc" 1>> "/root/.bashrc" 1>> "/root/.zshrc"
        fi

        printf "${C_W}> ${INFO} ${C_W}TTY theme has been set to ${C_C}"
        printf "${tty_theme}${N_F}.\n\n"

        cp -r "/post_install/files/tty_theme.d" "/etc"
}

