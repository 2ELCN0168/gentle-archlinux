create_themes() {

        export theme_color=""

        while true; do
                echo -e "\n==${C_CYAN}THEMES${NO_FORMAT}============\n"

                echo -e "${C_WHITE}[0] - ${C_WHITE}Catppuccin latte (light)${NO_FORMAT}"
                echo -e "${C_WHITE}[1] - ${C_CYAN}Tokyonight storm (dark)${NO_FORMAT} [default]"
                echo -e "${C_WHITE}[2] - ${C_RED}Red impact (dark)${NO_FORMAT}"
                echo -e "${C_WHITE}[3] - ${NO_FORMAT}Keep default TTY colors"

                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which theme do you prefer for your TTY? Each one will be created anyway. -> ${NO_FORMAT}\c"

                local tty_theme=""
                local ans_tty_theme=""
                read ans_tty_theme
                : "${ans_tty_theme:=1}"
                # echo ""

                case "${ans_tty_theme}" in
                        [0])
                                tty_theme="Catppuccin latte"
                                echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> "/etc/skel/.bashrc"
                                echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> "/etc/skel/.zshrc"
                                echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> "/root/.bashrc"
                                echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> "/root/.zshrc"
                                theme_color=0
                                break
                                ;;
                        [1])
                                tty_theme="Tokyonight Storm"
                                echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> "/etc/skel/.bashrc"
                                echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> "/etc/skel/.zshrc"
                                echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> "/root/.bashrc"
                                echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> "/root/.zshrc"
                                theme_color=1
                                break
                                ;;
                        [2])
                                tty_theme="Red impact"
                                echo "source /etc/tty_themes.d/tty_red_impact.sh" >> "/etc/skel/.bashrc"
                                echo "source /etc/tty_themes.d/tty_red_impact.sh" >> "/etc/skel/.zshrc"
                                echo "source /etc/tty_themes.d/tty_red_impact.sh" >> "/root/.bashrc"
                                echo "source /etc/tty_themes.d/tty_red_impact.sh" >> "/root/.zshrc"
                                theme_color=1
                                break
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
        
        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}TTY theme has been set to ${C_CYAN}${tty_theme}${NO_FORMAT}.\n"

        mkdir "/etc/tty_themes.d"

        cat << EOF > "/etc/tty_themes.d/tty_catppuccin_latte.sh"
        __tty_theme() {
                [ "\$TERM" = 'linux' ] || return # Only run in a TTY

                printf "\e]P0eff1f5" # black         rgb(239, 241, 245)  #eff1f5
                printf "\e]P1d20f39" # red           rgb(210, 15, 57)    #d20f39
                printf "\e]P240a02b" # green         rgb(64, 160, 43)    #40a02b
                printf "\e]P3df8e1d" # brown         rgb(223, 142, 29)   #df8e1d
                printf "\e]P41e66f5" # blue          rgb(30, 102, 245)   #1e66f5
                printf "\e]P58839ef" # magenta       rgb(136, 57, 239)   #8839ef
                printf "\e]P6179299" # cyan          rgb(23, 146, 153)   #179299
                printf "\e]PF4c4f69" # light_gray    rgb(76, 79, 105)    #4c4f69
                printf "\e]P86c6f85" # gray          rgb(108, 111, 133)  #6c6f85
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
   
        cat << EOF > "/etc/tty_themes.d/tty_tokyonight_storm.sh"
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

        cat << EOF > "/etc/tty_themes.d/tty_red_impact.sh"
        __tty_theme() {
                [ "\$TERM" = 'linux' ] || return # Only run in a TTY

                printf "\e]P0181425" # black         #181425
                printf "\e]P17c183c" # red           #7c183c
                printf "\e]P2d53c6a" # green         #d53c6a
                printf "\e]P3d53c6a" # brown         #d53c6a
                printf "\e]P4d53c6a" # blue          #d53c6a
                printf "\e]P5d53c6a" # magenta       #d53c6a
                printf "\e]P6d53c6a" # cyan          #d53c6a
                printf "\e]P7ffffff" # light_gray    #ffffff
                printf "\e]P8ffffff" # gray          #ffffff
                printf "\e]P97c183c" # bold_red      #d53c6a
                printf "\e]PAd53c6a" # bold_green    #d53c6a
                printf "\e]PBd53c6a" # bold_yellow   #d53c6a
                printf "\e]PCd53c6a" # bold_blue     #d53c6a
                printf "\e]PDd53c6a" # bold_magenta  #d53c6a
                printf "\e]PEd53c6a" # bold_cyan     #d53c6a
                printf "\e]PFffffff" # bold_white    #ffffff

                clear
        }

        __tty_theme
EOF

}

