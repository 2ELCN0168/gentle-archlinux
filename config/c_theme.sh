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

    printf "\e]P0181425" # black         rgb(27, 26, 38)     #181425
    printf "\e]P17c183c" # red           rgb(255, 117, 127)  #7c183c
    printf "\e]P2d53c6a" # green         rgb(158, 206, 106)  #d53c6a
    printf "\e]P3d53c6a" # brown         rgb(225, 174, 103)  #d53c6a
    printf "\e]P4d53c6a" # blue          rgb(122, 162, 247)  #d53c6a
    printf "\e]P5d53c6a" # magenta       rgb(185, 152, 245)  #d53c6a
    printf "\e]P6d53c6a" # cyan          rgb(124, 206, 255)  #d53c6a
    printf "\e]P7ffffff" # light_gray    rgb(192, 203, 245)  #ffffff
    printf "\e]P8ffffff" # gray          rgb(192, 203, 245)  #ffffff
    printf "\e]P97c183c" # bold_red      rgb(255, 117, 127)  #d53c6a
    printf "\e]PAd53c6a" # bold_green    rgb(158, 206, 106)  #d53c6a
    printf "\e]PBd53c6a" # bold_yellow   rgb(225, 174, 103)  #d53c6a
    printf "\e]PCd53c6a" # bold_blue     rgb(122, 162, 247)  #d53c6a
    printf "\e]PDd53c6a" # bold_magenta  rgb(185, 152, 245)  #d53c6a
    printf "\e]PEd53c6a" # bold_cyan     rgb(124, 206, 255)  #d53c6a
    printf "\e]PFffffff" # bold_white    rgb(192, 203, 245)  #ffffff

    clear
}
