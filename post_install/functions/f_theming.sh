create_themes() {

        export theme_color=""

        while true; do

                print_box "Themes" "${C_C}" 40 

                printf "${C_W}[0] - ${C_W}Catppuccin latte (light)${N_F}\n"
                printf "${C_W}[1] - ${C_C}Tokyonight storm (dark)${N_F} "
                printf "[default]\n"
                printf "${C_W}[2] - ${C_R}Red impact (dark)${N_F}\n"
                printf "${C_W}[3] - ${N_F}Keep default TTY colors\n\n"

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
                                path="/etc/tty_themes.d/tty_catppuccin_latte.sh"
                                printf "\nsource ${path}" \
                                1>> "/etc/skel/.bashrc" \
                                1>> "/etc/skel/.zshrc" \
                                1>> "/root/.bashrc" \
                                1>> "/root/.zshrc"
                                theme_color=0
                                break
                                ;;
                        [1])
                                tty_theme="Tokyonight Storm"
                                path="/etc/tty_themes.d/tty_tokyonight_storm.sh"
                                printf "\nsource ${path}" \
                                1>> "/etc/skel/.bashrc" \
                                1>> "/etc/skel/.zshrc" \
                                1>> "/root/.bashrc" \
                                1>> "/root/.zshrc"
                                theme_color=1
                                break
                                ;;
                        [2])
                                tty_theme="Red impact"
                                path="/etc/tty_themes.d/tty_red_impact.sh"
                                printf "\nsource ${path}" \
                                1>> "/etc/skel/.bashrc" \
                                1>> "/etc/skel/.zshrc" \
                                1>> "/root/.bashrc" \
                                1>> "/root/.zshrc"
                                theme_color=1
                                break
                                ;;
                        [3])
                                tty_theme="Default"
                                theme_color=2
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
        
        printf "${C_W}> ${INFO} ${C_W}TTY theme has been set to ${C_C}"
        printf "${tty_theme}${N_F}.\n\n"

        cp -r "./files/tty_theme.d" "/etc"
}

