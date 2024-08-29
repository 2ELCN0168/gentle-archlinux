# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

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

    clear
}

__tty_theme_hard() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0292d46" # black         rgb(27, 26, 38)     #292d46
    printf "\e]P1bb3840" # red           rgb(255, 117, 127)  #bb3840
    printf "\e]P2d7d6ce" # green         rgb(158, 206, 106)  #d7d6ce
    printf "\e]P36a334f" # brown         rgb(225, 174, 103)  #6a334f
    printf "\e]P44b4d6c" # blue          rgb(122, 162, 247)  #4b4d6c
    printf "\e]P5715d7e" # magenta       rgb(185, 152, 245)  #715d7e
    printf "\e]P69593a7" # cyan          rgb(124, 206, 255)  #9593a7
    printf "\e]P79593a7" # light_gray    rgb(192, 203, 245)  #9793a7
    printf "\e]P89593a7" # gray          rgb(192, 203, 245)  #9793a7
    printf "\e]P9ff757f" # bold_red      rgb(255, 117, 127)  #ff757f
    printf "\e]PAd7d6ce" # bold_green    rgb(158, 206, 106)  #d7d6ce
    printf "\e]PB6a334f" # bold_yellow   rgb(225, 174, 103)  #6a334f
    printf "\e]PC4b4d6c" # bold_blue     rgb(122, 162, 247)  #4b4d6c
    printf "\e]PD715d7e" # bold_magenta  rgb(185, 152, 245)  #715d7e
    printf "\e]PE9593a7" # bold_cyan     rgb(124, 206, 255)  #9593a7
    printf "\e]PFffffff" # bold_white    rgb(192, 203, 245)  #ffffff

    clear
}
