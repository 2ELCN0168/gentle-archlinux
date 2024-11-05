__tty_theme() {
        [ "$TERM" = 'linux' ] || return # Only run in a TTY

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
