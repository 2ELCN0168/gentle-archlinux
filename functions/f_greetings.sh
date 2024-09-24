# FUNCTION(S)
# ---
# Greetings is the initialization function, it displays the first messages 
# before starting and ensure there's nothing mounted on /mnt
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

#        ,                       _     _ _                       
#       /#\        __ _ _ __ ___| |__ | (_)_ __  _   ___  __     
#      ,###\      / _` | '__/ __| '_ \| | | '_ \| | | \ \/ /     
#     /#####\    | (_| | | | (__| | | | | | | | | |_| |>  <      
#    /##;-;##\    \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\TM   
#   /##(   )##`                                                  
#  /#;--   --;#\              Gentle Installer.                  
# /`           `\                                                


greetings() {
        clear

        local mini="${C_PINK}Minimal installation mode.${NO_FORMAT}"
        local complete="${C_GREEN}Complete installation mode.${NO_FORMAT}"
        local hard="${C_RED}Hardened installation mode.${NO_FORMAT}"
        local standard=""

        if [[ "${param_minimal}" -eq 0 ]]; then
                mini=""
        fi

        if [[ "${param_full}" -eq 0 ]]; then
                complete=""
        fi

        if [[ "${param_hardening}" -eq 0 ]]; then
                hard=""
        fi

        if [[ "${param_standard}" -eq 1 ]]; then
                standard="${C_CYAN}Standard installation mode.${NO_FORMAT}"
        
        fi

        echo ""
        echo -e "${C_BLUE}       ,       ${C_CYAN}                _     _ _                               "
        echo -e "${C_BLUE}      /#\      ${C_CYAN}  __ _ _ __ ___| |__ | (_)_ __  _   ___  __             "
        echo -e "${C_BLUE}     ,###\     ${C_CYAN} / _\` | '__/ __| '_ \| | | '_ \| | | \ \/ /            "
        echo -e "${C_BLUE}    /#####\    ${C_CYAN}| (_| | | | (__| | | | | | | | | |_| |>  <              "
        echo -e "${C_BLUE}   /##;-;##\   ${C_CYAN} \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\ ${C_GREEN}TM"
        echo -e "${C_BLUE}  /##(   )##\`                                                                  "
        echo -e "${C_BLUE} /#;--   --;#\  ${C_YELLOW}Gentle Installer. ${mini}${complete}${hard}${standard}"
        echo -e "${C_BLUE}/\`           \`\                                                               "
        echo -e "${NO_FORMAT}"

        echo -e "\n${C_WHITE}██████████████████████████████████████████████████████████████████████████████████████"
        echo -e "████████████████████████████████████████████████████"
        echo -e "████████████████\n${NO_FORMAT}"

        date
        echo -e "${C_CYAN}> ${C_WHITE}Welcome to this gently automated ${C_CYAN}Arch/\Linux${NO_FORMAT} ${C_WHITE}installer. ${C_CYAN}<${NO_FORMAT}\n"

        echo -e "${C_WHITE}> ${C_PINK}Before starting, make sure you have ${C_RED}no LVM ${C_PINK}configured on your disk, or it will ${C_RED}mess up${C_PINK} the script. You must delete any LV, VG and PV before starting.${NO_FORMAT}\n"

        # This unmounting action ensure to have nothing actually mounted on /mnt before starting
        umount -R "/mnt/*" 1> "/dev/null" 2>&1
}
