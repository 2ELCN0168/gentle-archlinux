create_themes() {

  mkdir -p /boot/EFI/refind/themes
  git clone https://github.com/catppuccin/refind /boot/EFI/refind/themes/catppuccin &> /dev/null

  local choice=0

  while true; do
    printf "==THEMES============"
    jump
    printf "${C_WHITE}[0] - ${C_WHITE}Catppuccin latte (light)${NO_FORMAT}\n"
    printf "${C_WHITE}[1] - ${C_CYAN}Tokyonight storm (dark)${NO_FORMAT} [default] \n"
    printf "${C_WHITE}[2] - ${NO_FORMAT}Keep default TTY colors"
    jump
    printf "====================\n"
    
    read -p "[?] - Which theme do you prefer for your TTY? " response
    local response=${response:-1}
    case "$response" in
      [0])
        echo include themes/catppuccin/latte.conf >> /boot/EFI/refind/refind.conf
        choice=0
        break
        ;;
      [1])
        echo include themes/catppuccin/mocha.conf >> /boot/EFI/refind/refind.conf
        choice=1
        break
        ;;
      [2])
        rm -rf /boot/EFI/refind/themes/catppuccin &> /dev/null
        choice=2
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  mkdir /etc/tty_themes.d

  if [[ $choice -eq 0 ]]; then
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /etc/skel/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /etc/skel/.zshrc 
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /root/.zshrc
    cat << EOF > /etc/tty_themes.d/tty_catppuccin_latte.sh

EOF
  elif [[ $choice -eq 1 ]]; then
    echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> /etc/skel/.bashrc
    echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> /etc/skel/.zshrc
    echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_tokyonight_storm.sh" >> /root/.zshrc
    cat << EOF > /etc/tty_themes.d/tty_tokyonight_storm.sh
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
  elif [[ $choice -eq 2 ]]; then
    continue
  fi

  

}
