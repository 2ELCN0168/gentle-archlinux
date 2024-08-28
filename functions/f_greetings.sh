# FUNCTION(S)
# ---
# Greetings is the initialization function, it displays the first messages 
# before starting and ensure there's nothing mounted on /mnt
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

greetings() {
        clear
        echo -e "${C_YELLOW}"
        echo -e " ▄▄ • ▄▄▄ . ▐ ▄ ▄▄▄▄▄▄▄▌  ▄▄▄ .                " 
        echo -e "▐█ ▀ ▪▀▄.▀·•█▌▐█•██  ██•  ▀▄.▀·                " 
        echo -e "▄█ ▀█▄▐▀▀▪▄▐█▐▐▌ ▐█.▪██▪  ▐▀▀▪▄                " 
        echo -e "▐█▄▪▐█▐█▄▄▌██▐█▌ ▐█▌·▐█▌▐▌▐█▄▄▌                " 
        echo -e "·▀▀▀▀  ▀▀▀ ▀▀ █▪ ▀▀▀ .▀▀▀  ▀▀▀                 " 
        echo -e " ▄▄▄· ▄▄▄   ▄▄·  ▄ .▄▄▄▌  ▪   ▐ ▄ ▄• ▄▌▐▄• ▄   " 
        echo -e "▐█ ▀█ ▀▄ █·▐█ ▌▪██▪▐███•  ██ •█▌▐██▪██▌ █▌█▌▪  "
        echo -e "▄█▀▀█ ▐▀▀▄ ██ ▄▄██▀▐███▪  ▐█·▐█▐▐▌█▌▐█▌ ·██·   " 
        echo -e "▐█ ▪▐▌▐█•█▌▐███▌██▌▐▀▐█▌▐▌▐█▌██▐█▌▐█▄█▌▪▐█·█▌  "
        echo -e " ▀  ▀ .▀  ▀·▀▀▀ ▀▀▀ ·.▀▀▀ ▀▀▀▀▀ █▪ ▀▀▀ •▀▀ ▀▀  "
        echo -e "${NO_FORMAT}"

        echo -e "${C_YELLOW}"
        cat << EOF >&1

        Bonjour
        Je
        Suis
        La
EOF                                         

echo -e "${NO_FORMAT}"

        echo -e "\n${C_CYAN}███${C_RED}█${C_CYAN}█${C_YELLOW}█${C_CYAN}█${NO_FORMAT}\n"

        date
        echo -e "${C_CYAN}> ${C_WHITE}Welcome to this gently automated ${C_CYAN}Arch/\Linux${NO_FORMAT} ${C_WHITE}installer. ${C_CYAN}<${NO_FORMAT}\n"

        echo -e "${C_WHITE}> ${C_PINK}Before starting, make sure you have ${C_RED}no LVM ${C_PINK}configured on your disk, or it will ${C_RED}mess up${C_PINK} the script. You must delete any LV, VG and PV before starting.${NO_FORMAT}\n"

        # This unmounting action ensure to have nothing actually mounted on /mnt before starting
        umount -R "/mnt" 1> "/dev/null" 2>&1
}
