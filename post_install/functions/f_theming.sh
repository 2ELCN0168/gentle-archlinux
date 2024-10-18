create_themes() {

        export theme_color=""

        while true; do
                printf "==${C_C}THEMES${N_F}============\n\n"

                printf "${C_W}[0] - ${C_W}Catppuccin latte (light)${N_F}\n"
                printf "${C_W}[1] - ${C_C}Tokyonight storm (dark)${N_F} "
                printf "[default]\n"
                printf "${C_W}[2] - ${C_R}Red impact (dark)${N_F}\n"
                printf "${C_W}[3] - ${N_F}Keep default TTY colors\n"

                printf "\n====================\n\n"

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

        mkdir "/etc/tty_themes.d"

        cat <<-EOF 1> "/etc/tty_themes.d/tty_catppuccin_latte.sh"
__tty_theme() {
        [ "\$TERM" = 'linux' ] || return # Only run in a TTY

        printf "\e]P0eff1f5" # black         rgb(239, 241, 245)  #eff1f5
        printf "\e]P1d20f39" # red           rgb(210, 15, 57)    #d20f39
        printf "\e]P240a02b" # green         rgb(64, 160, 43)    #40a02b
        printf "\e]P3df8e1d" # brown         rgb(223, 142, 29)   #df8e1d
        printf "\e]P41e66f5" # blue          rgb(30, 102, 245)   #1e66f5
        printf "\e]P58839ef" # magenta       rgb(136, 57, 239)   #8839ef
        printf "\e]P6179299" # cyan          rgb(23, 146, 153)   #179299
        printf "\e]P74c4f69" # light_gray    rgb(76, 79, 105)    #4c4f69
        printf "\e]P84c4f69" # gray          rgb(76, 79, 105)    #4c4f69
        printf "\e]P9e64553" # bold_red      rgb(230, 69, 83)    #e64553
        printf "\e]PA40a02b" # bold_green    rgb(64, 160, 43)    #40a02b
        printf "\e]PBdf8e1d" # bold_yellow   rgb(223, 142, 29)   #df8e1d
        printf "\e]PC04a5e5" # bold_blue     rgb(4, 165, 229)    #04a5e5
        printf "\e]PDea76cb" # bold_magenta  rgb(234, 118, 203)  #ea76cb
        printf "\e]PE209fb5" # bold_cyan     rgb(32, 159, 181)   #209fb5
        printf "\e]PF4c4f69" # bold_white    rgb(76, 79, 105)    #4c4f69

        clear # To fix the background
}

__tty_theme
EOF
   
        cat <<-EOF 1> "/etc/tty_themes.d/tty_tokyonight_storm.sh"
__tty_theme() {
        [ "\$TERM" = 'linux' ] || return # Only run in a TTY

        printf "\e]P01b1a26" # black         rgb(27, 26, 38)     #1b1a26
        printf "\e]P1ff757f" # red           rgb(255, 117, 127)  #ff757f
        printf "\e]P29ece6a" # green         rgb(158, 206, 106)  #9ece6a
        printf "\e]P3e1ae67" # brown         rgb(225, 174, 103)  #e1ae67
        printf "\e]P47aa2f7" # blue          rgb(122, 162, 247)  #7aa2f7
        printf "\e]P5b998f5" # magenta       rgb(185, 152, 245)  #b998f5
        printf "\e]P67cceff" # cyan          rgb(124, 206, 255)  #7cceff
        printf "\e]P7c0cbf5" # light_gray    rgb(192, 203, 245)  #c0cbf5
        printf "\e]P8c0cbf5" # gray          rgb(192, 203, 245)  #c0cbf5
        printf "\e]P9ff757f" # bold_red      rgb(255, 117, 127)  #ff757f
        printf "\e]PA9ece6a" # bold_green    rgb(158, 206, 106)  #9ece6a
        printf "\e]PBe1ae67" # bold_yellow   rgb(225, 174, 103)  #e1ae67
        printf "\e]PC7aa2f7" # bold_blue     rgb(122, 162, 247)  #7aa2f7
        printf "\e]PDb998f5" # bold_magenta  rgb(185, 152, 245)  #b998f5
        printf "\e]PE7cceff" # bold_cyan     rgb(124, 206, 255)  #7cceff
        printf "\e]PFc0cbf5" # bold_white    rgb(192, 203, 245)  #c0cbf5

        clear # To fix the background
}

__tty_theme
EOF

        cat <<-EOF 1> "/etc/tty_themes.d/tty_red_impact.sh"
__tty_theme() {
        [ "\$TERM" = 'linux' ] || return # Only run in a TTY

        printf "\e]P0181425" # black         #181425
        printf "\e]P1FF204E" # red           #FF204E
        printf "\e]P2A0153E" # green         #A0153E
        printf "\e]P3A0153E" # brown         #A0153E
        printf "\e]P4A0153E" # blue          #A0153E
        printf "\e]P5A0153E" # magenta       #A0153E
        printf "\e]P6A0153E" # cyan          #A0153E
        printf "\e]P7ffffff" # light_gray    #ffffff
        printf "\e]P8ffffff" # gray          #ffffff
        printf "\e]P9FF204E" # bold_red      #FF204E
        printf "\e]PAFF204E" # bold_green    #FF204E
        printf "\e]PBFF204E" # bold_yellow   #FF204E
        printf "\e]PCFF204E" # bold_blue     #FF204E
        printf "\e]PDFF204E" # bold_magenta  #FF204E
        printf "\e]PEFF204E" # bold_cyan     #FF204E
        printf "\e]PFffffff" # bold_white    #ffffff

        clear
}

__tty_theme
EOF

}

